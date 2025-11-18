import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/sources/data_state.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../services/get_it.dart';
import '../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../../../user/profiles/domain/entities/user_entity.dart';
import '../../../../user/profiles/domain/usecase/get_user_by_uid.dart';

class VisitCalenderTile extends StatelessWidget {
  const VisitCalenderTile({super.key, required this.visit});
  final VisitingEntity visit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataState<UserEntity?>>(
      future: GetUserByUidUsecase(locator()).call(visit.visiterID),
      builder: (BuildContext context,
          AsyncSnapshot<DataState<UserEntity?>> snapshot) {
        // Default fallback
        String visitorName = visit.visiterID;
        String? profilePhotoURL;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildSkeletonTile(context);
        }

        if (snapshot.hasData && snapshot.data is DataSuccess<UserEntity?>) {
          final UserEntity? user =
              (snapshot.data as DataSuccess<UserEntity?>).entity;
          if (user != null) {
            visitorName = user.displayName;
            profilePhotoURL = (user.profilePhotoURL != null &&
                    user.profilePhotoURL!.isNotEmpty)
                ? user.profilePhotoURL
                : null;
          }
        }
        return Container(
          margin: const EdgeInsets.only(left: 50),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomNetworkImage(
                  size: 40,
                  imageURL: profilePhotoURL,
                  placeholder: visitorName,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      visitorName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Icon(Icons.access_time,
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7)),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat.jm().format(visit.dateTime)} - ${DateFormat.jm().format(visit.dateTime.add(const Duration(minutes: 30)))}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonTile(BuildContext context) {
    // Placeholder while loading
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Container(width: 40, height: 40, color: Colors.grey.shade300),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 12, width: 100, color: Colors.grey.shade300),
                const SizedBox(height: 4),
                Container(height: 10, width: 140, color: Colors.grey.shade300),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 20, color: Colors.grey),
        ],
      ),
    );
  }
}
