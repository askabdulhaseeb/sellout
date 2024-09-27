import 'package:flutter/material.dart';

class CustomLinearProgressBar extends StatelessWidget {
  const CustomLinearProgressBar({
    required this.completed,
    this.total = 10,
    super.key,
  });
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 8,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: completed,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (total - completed > 0)
                  Expanded(
                    flex: total - completed,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
