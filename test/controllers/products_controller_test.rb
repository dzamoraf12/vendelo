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
end
