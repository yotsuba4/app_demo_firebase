import 'package:app_demo_firebase/constants/asset_path.dart';
import 'package:app_demo_firebase/constants/controllers.dart';
import 'package:app_demo_firebase/models/device.dart';
import 'package:app_demo_firebase/screens/home/widgets/single_device_draggable.dart';
import 'package:app_demo_firebase/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class DeviceWidget extends StatelessWidget {
  final DeviceModel device;

  const DeviceWidget({Key key, @required this.device}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        appController.changeActiveDeviceTo(device);
        appController.changeActiveDraggableWidgetTo(SingleDeviceDraggable());
      },
      leading: Image.asset(
        _returnImage(),
        width: 45,
      ),
      title: CustomText(
        text: device.name,
        size: 18,
        weight: FontWeight.bold,
      ),
      subtitle: CustomText(
        text: "Last log 2 days ago",
        color: Colors.grey,
      ),
    );
  }

  String _returnImage() {
    if (device.os == "android") {
      return android;
    } else {
      return iphone;
    }
  }
}
