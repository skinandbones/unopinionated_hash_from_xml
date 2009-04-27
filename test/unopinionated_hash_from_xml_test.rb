require 'test_helper'
require 'unopinionated_hash_from_xml'

class UnopinionatedHashFromXmlTest < ActiveSupport::TestCase
  
  def get_keys(params)
    case params.class.to_s
      when "Hash"
        params.inject([]) do |a, (k,v)|
          a << k
          a += get_keys(v)
          a
        end
      when "Array"
        params.map { |a| get_keys(a) }
      else
        []
    end    
  end
  
  context "The Hash class" do

    should "respond to from_xml" do
      assert_respond_to Hash, :from_xml
    end

    context "when calling from_xml" do

      setup do
        @xml = <<-END
          <doc>
            <titleSize>20</titleSize>
            <bodySize>10</bodySize>
            <footer-size>10</footer-size>
            <title>Stuff</title>
            <TopLevel>
              <middle-level-one>
                <bottom>1</bottom>
              </middle-level-one>
              <middleLevelTwo>
                <Bottom>2</Bottom>
              </middleLevelTwo>
            </TopLevel>
          </doc>
        END

        @renamed_keys   = %w[ 
          doc title_size body_size footer_size title top_level
          middle_level_one bottom middle_level_two bottom 
        ]

        @unrenamed_keys = %w[
          doc titleSize bodySize footer-size title TopLevel
          middle-level-one bottom middleLevelTwo Bottom
        ]
        
      end

      should "return a Hash" do
        assert_kind_of Hash, Hash.from_xml(@xml)
      end

      should "rename the keys by default" do
        h = Hash.from_xml(@xml)
        assert_same_elements(@renamed_keys, get_keys(h))
      end

      should "rename the keys (when option given)" do
        h = Hash.from_xml(@xml, :unrename_keys => true)
        assert_same_elements(@renamed_keys, get_keys(h))
      end
      
      should "not rename the keys" do
        h = Hash.from_xml(@xml, :unrename_keys => false)
        assert_same_elements(@unrenamed_keys, get_keys(h))
      end
      
      context "with junk options" do
        
        setup do
          @options = { :do_magic => true }
        end
        
        should "rename the keys by default" do
          h = Hash.from_xml(@xml, @options)
          assert_same_elements(@renamed_keys, get_keys(h))
        end

        should "rename the keys (when option given)" do
          h = Hash.from_xml(@xml, @options.merge(:unrename_keys => true))
          assert_same_elements(@renamed_keys, get_keys(h))
        end

        should "not rename the keys" do
          h = Hash.from_xml(@xml, @options.merge(:unrename_keys => false))
          assert_same_elements(@unrenamed_keys, get_keys(h))
        end

      end
            
    end
    
  end
  
end
