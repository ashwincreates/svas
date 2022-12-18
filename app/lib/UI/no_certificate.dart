import 'package:flutter/material.dart';

class NoCertificate extends StatelessWidget {
  const NoCertificate({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
          child: Row(
            children: [
              const Text("Not Certified Yet?"),
              TextButton(
                onPressed: () => {},
                child: const Text("Apply Now"))
            ]
          )
        ),
    );
  }
}