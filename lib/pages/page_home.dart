import 'package:festzap_test/controllers/controller_chat.dart';
import 'package:festzap_test/controllers/controller_page_home.dart';
import 'package:festzap_test/main.dart';
import 'package:festzap_test/models/state.dart';
import 'package:festzap_test/routes.dart';
import 'package:festzap_test/utils/formatter.dart';
import 'package:festzap_test/widgets/app_bar.dart';
import 'package:festzap_test/widgets/loading.dart';
import 'package:flutter/material.dart';

class PageHome extends StatelessWidget {
  final controller = ControllerPageHome.instance;
  final image =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  PageHome() {
    controller.getCalls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(label: 'FestZap'),
      body: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext? _, Widget? __) {
          return _body();
        },
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
            leading: CircleAvatar(backgroundImage: NetworkImage(this.image)),
            onTap: () async {
              await navigator.pushNamed(
                NameRoutes.chat,
                arguments: [call.uuid, call.client!.name],
              );
              ControllerChat.instance.channel.sink.close();
            });
      },
    );
  }
}
