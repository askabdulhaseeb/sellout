import 'package:flutter/material.dart';
import '../../../../../../core/widgets/custom_svg_icon.dart';
import '../../../../../settings/views/screens/connect_bank_screen.dart';

class ConnectBankSettingTile extends StatelessWidget {
  const ConnectBankSettingTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ConnectBankScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).dividerColor,
              child: CustomSvgIcon(
                assetPath:
                    'assets/icons/bank.svg', // Add your bank icon SVG here
                color: Colors.red,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Connect Bank Account',
                style: TextTheme.of(context).bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
