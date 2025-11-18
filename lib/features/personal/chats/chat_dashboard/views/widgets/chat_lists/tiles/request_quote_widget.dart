import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../core/widgets/custom_elevated_button.dart';

class EditableQuoteDialog extends StatefulWidget {
  const EditableQuoteDialog({super.key});

  @override
  EditableQuoteDialogState createState() => EditableQuoteDialogState();
}

class EditableQuoteDialogState extends State<EditableQuoteDialog> {
  final TextEditingController titleController =
      TextEditingController(text: 'Quote title here');
  final TextEditingController priceController =
      TextEditingController(text: '100.0');
  DateTime selectedDate = DateTime.now();
  List<String> includedServices = <String>[];
  List<String> excludedServices = <String>[];

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _editServices(List<String> services, String type) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Edit $type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter service')),
            const SizedBox(height: 10),
            ...services.map((String service) => ListTile(
                  title: Text(service),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        services.remove(service);
                      });
                      Navigator.pop(context);
                      _editServices(services, type);
                    },
                  ),
                )),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  services.add(controller.text);
                });
                controller.clear();
                Navigator.pop(context);
                _editServices(services, type);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme texttheme = Theme.of(context).textTheme;
    final ColorScheme colorscheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Quote for Customer', style: texttheme.titleMedium),
                    SizedBox(
                      height: 40,
                      width: 150,
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Quote Title',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${DateFormat.yMMMd().format(selectedDate)}',
                      style: texttheme.bodyMedium?.copyWith(
                          color: colorscheme.onSurface.withAlpha(200)),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 60,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixText: '\$',
                          hintText: 'Price',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _editServices(includedServices, 'Included Services'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Includes:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...includedServices
                      .map((String service) => Text('- $service')),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _editServices(excludedServices, 'Excluded Services'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Does not include:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...excludedServices
                      .map((String service) => Text('- $service')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CustomElevatedButton(
                    bgColor: Colors.transparent,
                    textColor: Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    onTap: () {},
                    title: 'Cancel',
                    isLoading: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomElevatedButton(
                    onTap: () {},
                    title: 'Send',
                    isLoading: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
