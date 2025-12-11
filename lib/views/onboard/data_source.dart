import 'package:moneytracker/utilis/assets_path.dart';
import 'package:moneytracker/utilis/strings.dart';

class DataSource {
  
  static List<DataModel> rowData = [
      DataModel(id: 1, images: SvgImagesPath.onboardImageOne, title: AppStrings.onBoardtitle1, buttonTitle: "Next"),
      DataModel(id: 2, images: SvgImagesPath.onboardImagetwo, title: AppStrings.onBoardtitle2, buttonTitle: "Next"),
      DataModel(id: 3, images: SvgImagesPath.onboardImageThree, title: AppStrings.onBoardtitle3, buttonTitle:"Done"),
   ];
   
}



class DataModel {
  final int id;
  final String images;
  final String title;
  final String buttonTitle;

  DataModel({ required this.id, required this.images, required this.title, required this.buttonTitle});

}