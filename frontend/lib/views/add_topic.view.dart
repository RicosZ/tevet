// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:getx_1/api/topic.api.dart';
import 'package:getx_1/controllers/add_topic.controller.dart';
// import 'package:getx_1/models/category_list.dart';
import 'package:getx_1/models/tag.dart';
// import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class addTopicView extends StatelessWidget {
  addTopicView({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();
  final addtopicController = Get.put(addTopicController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Topic',style: TextStyle(fontSize: 32),),
                ),
              ),
              // Obx(
              //   () => MultiSelectDialogField(
              //     listType: MultiSelectListType.LIST,
              //     // chipDisplay: MultiSelectChipDisplay.none(),
              //     decoration: BoxDecoration(
              //       color: Colors.blue.withOpacity(0.1),
              //       borderRadius: BorderRadius.all(Radius.circular(40)),
              //       border: Border.all(color: Colors.white, width: 2),
              //     ),
              //     buttonIcon: Icon(
              //       Icons.people,
              //       color: Colors.blue,
              //     ),
              //     buttonText: Text(
              //       'Select Category',
              //       style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              //     ),
              //     items: addtopicController.cat
              //         .map((cat) =>
              //             MultiSelectItem<CategoryListData>(cat, cat.catName))
              //         .toList(),
              //     onConfirm: (result) {
              //       // print(result);
              //       addtopicController.selectCategory = result;
              //       // addtopicController.selectedCategory.value = '';
              //       // addtopicController.selectCategory.forEach((element) {
              //       //   print(element.catName);
              //       //   //   addtopicController.selectedCategory.value =
              //       //   //       addtopicController.selectedCategory.value +
              //       //   //           ' ' +
              //       //   //           element.catName;
              //       // });
              //     },
              //   ),
              // ),
              Obx(
                () => DropdownButton(
                  hint: Obx(() => Text(
                        addtopicController.hint.toString(),
                      )),
                  items: addtopicController.cat.map((cat) {
                    return DropdownMenuItem(
                      child: Text(cat.catName),
                      value: cat.catName,
                      onTap: () => addtopicController.selectCategory = cat,
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    addtopicController.hint.value = newValue.toString();
                    // print(newValue.toString());
                  },
                ),
              ),
              Obx(
                () => MultiSelectDialogField(
                  listType: MultiSelectListType.LIST,
                  // chipDisplay: MultiSelectChipDisplay.none(),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  buttonIcon: Icon(
                    Icons.people,
                    color: Colors.blue,
                  ),
                  buttonText: Text(
                    'Select Tag',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                  ),
                  items: addtopicController.tag
                      .map((tag) => MultiSelectItem<TagData>(tag, tag.name))
                      .toList(),
                  onConfirm: (result) {
                    // print(result);
                    addtopicController.selectTag = result;
                    // addtopicController.selectedCategory.value = '';
                    // addtopicController.selectTag.forEach((element) {
                    //   print(element.name);

                    //   //   print(element.catName);
                    //   //   //   addtopicController.selectedCategory.value =
                    //   //   //       addtopicController.selectedCategory.value +
                    //   //   //           ' ' +
                    //   //   //           element.catName;
                    // });
                  },
                ),
              ),

              FormBuilderTextField(name: 'topicSubject'),
              FormBuilderTextField(name: 'topicDetail'),
              ElevatedButton(
                  onPressed: () async {
                    // addtopicController.selectCategory.forEach((element) {
                    //   print(element.catName);
                    //   //   addtopicController.selectedCategory.value =
                    //   //       addtopicController.selectedCategory.value +
                    //   //           ' ' +
                    //   //           element.catName;
                    // });
                    _formKey.currentState!.save();
                    final topicSubject =
                        _formKey.currentState?.fields['topicSubject']!.value;
                    final topicDetail =
                        _formKey.currentState?.fields['topicDetail']!.value;
                    // print(topicSubject);
                    // print(topicDetail);
                    // await
                    print(addtopicController.selectCategory!);
                    TopicApi().createTopic(
                        category: addtopicController.selectCategory!,
                        topicSubject: topicSubject,
                        topicDetail: topicDetail,
                        topicBy: '62d8ffee5edc5531fa46a06a',
                        tags: addtopicController.selectTag);
                    // Get.toNamed("/category");
                  },
                  child: Text('Post'))
            ],
          ),
        ),
      ),
    );
  }
}
