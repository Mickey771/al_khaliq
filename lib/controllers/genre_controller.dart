
import 'package:al_khaliq/services/genre_services.dart';
import 'package:get/get.dart';

import '../onboarding/login.dart';




class GenreController extends GetxController {




  RxBool genreLoadingStatus = false.obs;

  RxList genres = [].obs;




  getGenres(token) async {
    genreLoadingStatus.value = true;
    GenreServices.getGenres((status, response) {
      if (status) {
        genreLoadingStatus.value = false;
        genres.value = response['data'];

      } else {
        genreLoadingStatus.value = false;
        // showFlashError(context, response);
        Get.back();
      }
    }, token);
  }



  signOut(token) async {
    // Get.to(() => Loading());
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    Get.offAll(() => Login());
  }


}
