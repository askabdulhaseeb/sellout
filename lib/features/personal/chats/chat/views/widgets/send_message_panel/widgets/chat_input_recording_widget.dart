// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:voice_note_kit/recorder/voice_enums/voice_enums.dart';
// import 'package:voice_note_kit/recorder/voice_recorder_widget.dart';
// import 'package:easy_localization/easy_localization.dart';
// import '../../../../../../../../core/theme/app_theme.dart';
// import '../../../../../../../attachment/domain/entities/picked_attachment.dart';
// import '../../../providers/send_message_provider.dart';

// class VoiceRecorderWIdget extends StatefulWidget {
//   const VoiceRecorderWIdget({super.key});

//   @override
//   State<VoiceRecorderWIdget> createState() => _VoiceRecorderWIdgetState();
// }

// class _VoiceRecorderWIdgetState extends State<VoiceRecorderWIdget> {
//   File? recordedFile;
//   String? recordedAudioBlobUrl;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: VoiceRecorderWidget(
//         timerTextStyle: TextTheme.of(context).labelMedium,
//         iconSize: 50,
//         showTimerText: true,
//         showSwipeLeftToCancel: true,
//         style: VoiceUIStyle.compact,
//         maxRecordDuration: const Duration(seconds: 60),
//         backgroundColor: AppTheme.primaryColor,
//         iconColor: ColorScheme.of(context).onPrimary,
//         cancelHintColor: Colors.red,
//         timerFontSize: 18,
//         permissionNotGrantedMessage: tr('voice.permission_required'),
//         dragToLeftText: tr('voice.swipe_to_cancel'),
//         dragToLeftTextStyle: const TextStyle(fontSize: 12),
//         cancelDoneText: tr('voice.recording_cancelled'),
//         onRecorded: (File file) async {
//           setState(() {
//             recordedFile = file;
//           });

//           final PickedAttachment attachment = PickedAttachment(
//             file: file,
//             type: AttachmentType.audio,
//           );

//           final SendMessageProvider chatPro =
//               Provider.of<SendMessageProvider>(context, listen: false);
//           chatPro.addAttachment(attachment);
//           await chatPro.sendMessage(context);
//           chatPro.stopRecording();

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(tr('voice.recording_saved'))),
//           );
//         },
//         onRecordedWeb: (String url) {
//           setState(() {
//             recordedAudioBlobUrl = url;
//           });
//         },
//         onError: (String error) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('${tr('voice.error')}: $error')),
//           );
//         },
//         actionWhenCancel: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(tr('voice.recording_cancelled'))),
//           );
//         },
//       ),
//     );
//   }
// }
