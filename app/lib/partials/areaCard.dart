import 'package:app/model/area.dart';
import 'package:app/model/license.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreaCard extends StatelessWidget {
  final AreaInfo area;
  const AreaCard({Key? key, required this.area}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    License lic = Provider.of<License>(context);
    return Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                area.name!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(area.address!),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Radius",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "${area.radius.toString()}m",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => lic.createLicense(area.id),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    child: const Text("Apply for License"),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
