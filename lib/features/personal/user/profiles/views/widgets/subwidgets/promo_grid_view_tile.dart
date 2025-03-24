import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../../core/widgets/in_dev_mode.dart';

class PromoGridViewTile extends StatelessWidget {
  const PromoGridViewTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const CustomNetworkImage(
                fit: BoxFit.cover,
                imageURL:
                    'https://s3-alpha-sig.figma.com/img/2157/4a82/0eb52cab6ff7020f17b97973a8a66f23?Expires=1743379200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=t3ALp~tPGGIBGDT~1g~ouK5ANRysQZ-8P-NpQO8aqU1B0EEkz8iUlgVsgfwlho-8vqgF~RGTyA-v1US8OkmgMGrlW7hGmXLpR2ftynF8pC1hOAn2WbJXmp6ZB5xYG1jN4Fsr6uEZi3IhH~XBIkK7zGMuymSNsw4uQ1XmHZvZKSrAOYOmVV1x8r20OFbo0Z2zCRj634YMmhwgy~HcQtcL2u3I~rOITrCqTQjRPSrSgkefYiCxxpCwWVJpZW7OhFlYQ7SUstHbv0uiFVV1UQ0DvPrF~eFRl8UBbvgL~NJTWmU2On1ggA-BEibRO~~UHwHE15TQWUzx-Qx5jxHKlOaxqA__',
              ),
            ),
          ),
        ),
        InDevMode(
          child: Row(
            spacing: 2,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 200),
                  ),
                  child: Text(
                    'promote'.tr(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 200)),
                  child: Text(
                    'edit'.tr(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
