import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/home_controller.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:weather_app/screens/weather_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverAppBar(
          floating: true,
          leading: IconButton(
            onPressed: controller.changeTheme,
            icon: Obx(() => Icon(controller.darkMode.value
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined)),
          ),
          actions: [
            IconButton(
                tooltip: "Current Location",
                icon: const Icon(Icons.location_on),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  controller.getCurrentLocationData();
                })
          ],
          title: /* SearchAnchor.bar(
            barLeading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                )),
            searchController: controller.textController,
            barHintText: "Search location",
            // viewLeading: IconButton(
            //     onPressed: () {
            //       controller.textController
            //           .closeView(controller.textController.text);
            //     },
            //     icon: const Icon(Icons.arrow_back_ios)),
            //  onTap: () {
            //    controller.textController.openView();
            //  },
            barTrailing: [
              IconButton(
                  tooltip: "Current Location",
                  icon: const Icon(Icons.location_on),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    controller.getCurrentLocationData();
                  })
            ],
            suggestionsBuilder: ((context, searchController) async {
              controller.getLocationSuggestions();
              return List.generate(controller.suggestions.length, (index) {
                String text = controller.suggestions[index]["city"] +
                    ", " +
                    controller.suggestions[index]["region"] +
                    ", " +
                    controller.suggestions[index]["country"];
                print("From: suggestions: $text");
                return Obx(() {
                  return ListTile(
                    title: Text(text),
                    onTap: () {
                      controller.textController.text = text;
                      searchController.closeView(text);
                      controller.getWeather(controller.suggestions[index]);
                      FocusScope.of(context).unfocus();
                    },
                  );
                });
              });
            })), */

              GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreeen()));
            },
            child: TextField(
              controller: controller.textController,
              enabled: false,
              decoration: const InputDecoration(
                  hintText: "Search here", border: InputBorder.none),
            ),
          )),
      SliverToBoxAdapter(
          child: Obx(() => controller.isLoading.value
              ? const SizedBox(
                  height: 500,
                  child: Center(child: CircularProgressIndicator.adaptive()))
              : const WeatherWidget()))
    ]));
  }
}
