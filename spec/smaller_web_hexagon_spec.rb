require_relative '../src/smaller_web_hexagon'
require_relative '../src/rack_http_adapter'
require_relative '../src/raters'

# The first 2 tests check the primary adapter swaps, using direct API access for the left
# The last test checks the secondary adapter swap, using Rack input.
# The config.ru file runs the real server stuff, for the final usage test.

# note about the tests, I made all the raters give different answers,
# so that I can see if they are hooked up wrong

describe 'requests' do
  subject { SmallerWebHexagon.new(rater) }
  let(:rate) { subject.rate_and_result(value)[0] }
  let(:result) { subject.rate_and_result(value)[1] }

  context 'bypassing the primary adapter' do

    context 'with the in-memory rater' do
      let(:rater) { InCodeRater.new }

      context 'and a low value' do
        let(:value) { 100 }

        it 'uses the correct rate' do
          expect(rate).to be == 1.01
        end

        it 'calculates the correct result' do
          expect(result).to be == value * 1.01
        end
      end  

      context 'and a high value' do
        let(:value) { 200 }

        it 'uses the correct rate' do
          expect(rate).to be == 1.5
        end

        it 'calculates the correct result' do
          expect(result).to be == value * 1.5
        end
      end  
    end

    context 'with the file rater' do
      let(:rater) { FileRater.new('test/file_rater.txt') }

      context 'and a low value' do
        let(:value) { 10 }

        it 'uses the correct rate' do
          expect(rate).to be == 1.00
        end

        it 'calculates the correct result' do
          expect(result).to be == value * 1.00
        end
      end  

      context 'and a high value' do
        let(:value) { 100 }

        it 'uses the correct rate' do
          expect(rate).to be == 2.0
        end

        it 'calculates the correct result' do
          expect(result).to be == value * 2.0
        end
      end  
    end
  end

  context 'using the rack http primary adapter' do
    let(:rater) { InCodeRater.new }
    let(:value) { 100 }

    it 'generates the correct HTML' do
      viewsFolder = 'src/views/'
      adapter = RackHttpAdapter.new(subject, viewsFolder)
      http_request = Rack::MockRequest.new(adapter)
      response = http_request.request('GET', "/#{value}") # sends the req through the Rack call(env) chain
      out = {               # expected values
          out_action:   "result_view",
          value:  value,
          rate:   1.01,
          result: value * 1.01
      }
      expect(response.body).to be == html_from_templatefile( viewsFolder + "result_view.erb" , binding )
    end
  end

end
