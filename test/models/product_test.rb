require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "Test Book Title",
                          description: "desc",
                          image_url: "test.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "Test Book Title",
                description: "desc",
                price: 1,
                image_url: image_url)
  end

  test "image url validity" do
    valid_image_names = %w{ fred.gif fred.jpg fred.png FRED.JPG
                            FRED.Jpg http://a.b.b/x/y/z/fred.gif }
    invalid_image_names = %w{ fred.doc fred.gif/more fred.gif.more }
    valid_image_names.each do |valid_image_name|
      assert new_product(valid_image_name).valid?, "#{valid_image_name} should be valid"
    end
    invalid_image_names.each do |invalid_image_name|
      assert new_product(invalid_image_name).invalid?, "#{invalid_image_name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "desc",
                          price: 1,
                          image_url: "test.jpg")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
