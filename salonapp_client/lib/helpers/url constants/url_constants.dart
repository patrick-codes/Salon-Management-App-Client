class UrlConstants {
  static String baseUrl = "https://fakestoreapi.com";

  //Products EndPoints
  static String getallproducts = "https://fakestoreapi.com/products";
  static String getsingleproduct = "$baseUrl/products/1";

  //Category EndPoints
  static String getallcategory = "$baseUrl/products/categories";
  static String getsinglecategory = "$baseUrl/products/jewelry";

  //Cart EndPoints
  static String getallcarts = "$baseUrl/products/carts";
  static String getsinglecart = "$baseUrl/products/carts/5";

  //Google Drive API
  static String clientId =
      "942271446904-59v7331klq1k7j25tgp0q3hn63g8g05g.apps.googleusercontent.com";
  static String apiKey = "AIzaSyAMQ8djnTHcWF00DXZ9W28Pdl_ALN8qboY";
}
