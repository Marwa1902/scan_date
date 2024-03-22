import 'package:flutter/material.dart';

void imagePickerModal(BuildContext context, {VoidCallback? onCameraTap, VoidCallback? onAddManuallyTap}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        height: 220,
        child: Column(
          children: [
            GestureDetector(
              onTap: onCameraTap,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(color: Colors.blue),
                child: const Text("Scan With Camera",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: onAddManuallyTap,
                child: Card(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Text("Add Manually",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ),
                  ),
                ),
              ],
            ),
          );
    },
  );
}


