import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/home_controller.dart';
import 'package:weather_app/models/location_model.dart';

class SearchScreeen extends GetView<HomeController> {
  const SearchScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          canRequestFocus: true,
          autofocus: true,
          controller: controller.textController,
          onEditingComplete: () async {
            controller.isLoading.value = true;
            await controller.getLocationSuggestions();
            controller.isLoading.value = false;
          },
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              itemCount: controller.suggestions.length,
              itemBuilder: (context, index) {
                String text = (controller.suggestions[index]["city"] ?? "") +
                    ", " +
                    (controller.suggestions[index]["region"] != null
                        ? (controller.suggestions[index]["region"] + ", ")
                        : "") +
                    (controller.suggestions[index]["country"] ?? "");
                return ListTile(
                  title: Text(text),
                  onTap: () {
                    controller.textController.text = text;
                    controller.currentLocation.value =
                        LocationModel.fromJson(controller.suggestions[index]);

                    controller.getForecast();
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                );
              })),
    );
  }
}
