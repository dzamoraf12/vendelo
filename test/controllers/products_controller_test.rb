class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get a list of products" do
    get products_path

    assert_response :success
    assert_select ".product", 2
  end

  test "should show product details" do
    product = products(:ps4)
    get product_path(product)

    assert_response :success
    assert_select ".title", "PS4 Fat"
    assert_select ".description", "Description: En muy buen estado"
    assert_select ".price", "Price: $8,000.00"
  end

  test "should get new product form" do
    get new_product_path
    assert_response :success
    assert_select "h2", "Create New Product"
    assert_select "form"
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_path, params: {
        product: {
          title: "New Product",
          description: "Product description",
          price: 9.99
        }
      }
    end
    assert_redirected_to product_path(Product.last)
    assert_equal "Product created successfully.", flash[:notice]
  end

  test "should not create product with invalid data" do
    assert_no_difference("Product.count") do
      post products_path, params: {
        product: {
          title: "",
          description: "Product description",
          price: -9.99
        }
      }
    end
    assert_response :unprocessable_entity
    assert_select "h2", "Create New Product"
    assert_select "form"
  end
end
