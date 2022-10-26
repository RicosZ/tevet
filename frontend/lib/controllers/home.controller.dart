// import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:getx_1/models/product.dart';

class HomeController extends GetxController {
  var products = <Product>[].obs;

  void onInit() {
    fetchProduct();
    super.onInit();
  }

  void fetchProduct() async {
    await Future.delayed(Duration(seconds: 2));
    var productResult = [
      Product(id: 1, PName: 'pen', PImage: 'PImage', PDes: 'PDes', Price: 10),
      Product(
          id: 2, PName: 'pencul', PImage: 'PImage', PDes: 'PDes', Price: 1067),
      Product(
          id: 3, PName: 'penaa', PImage: 'PImage', PDes: 'PDes', Price: 1066),
    ];
    products.assignAll(productResult);
  }

}
