import 'package:festzap_test/const/app_images.dart';
import 'package:festzap_test/controllers/controller_chat.dart';
import 'package:festzap_test/controllers/controller_page_home.dart';
import 'package:festzap_test/main.dart';
import 'package:festzap_test/models/state.dart';
import 'package:festzap_test/routes.dart';
import 'package:festzap_test/utils/formatter.dart';
import 'package:festzap_test/widgets/app_bar.dart';
import 'package:festzap_test/widgets/loading.dart';
import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final controller = ControllerPageHome.instance;

  @override
  void initState() {
    controller.getCalls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: 'FestZap'),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, widget) => _body(),
      ),
    );
  }

  Widget _body() {
    if (controller.state == modelState.loading) return CustomLoading();

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: controller.listCalls.length,
      itemBuilder: (context, index) {
        final call = controller.listCalls[index];
        String date = "";
        if (call.lastMessage?.createdAt != null) {
          date = Formatter.date(
            call.lastMessage!.createdAt!,
          );
        }

        return ListTile(
          title: Text("${call.client?.name}"),
          subtitle: Text("${call.lastMessage?.message ?? ''}"),
          trailing: Text(
            "$date",
            textAlign: TextAlign.end,
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(AppImageNet.profile),
          ),
          onTap: () async {
            await navigator.pushNamed(
              NameRoutes.chat,
              arguments: [call.uuid, call.client!.name],
            );
            ControllerChat.instance.channel.sink.close();
          },
        );
      },
    );
  }
}
