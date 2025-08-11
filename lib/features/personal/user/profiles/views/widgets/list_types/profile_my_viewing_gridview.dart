import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/sources/data_state.dart';
import '../../../../../../../services/get_it.dart';
import '../../../../../auth/signin/data/sources/local/local_auth.dart';
import '../../../../../post/domain/entities/visit/visiting_entity.dart';
import '../../../data/sources/local/local_visits.dart';
import '../../../domain/usecase/get_my_host_usecase.dart';
import '../subwidgets/profile_visit_gridview_tile.dart';

class ProfileMyViewingGridview extends StatelessWidget {
  const ProfileMyViewingGridview({super.key});

  @override
  Widget build(BuildContext context) {
    final GetImHostUsecase usecase = GetImHostUsecase(locator());
    return FutureBuilder<DataState<List<VisitingEntity>>>(
      future: usecase(LocalAuth.uid ?? ''),
      initialData: LocalVisit().iMhost(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DataState<List<VisitingEntity>>> snapshot,
      ) {
        final List<VisitingEntity> visits =
            snapshot.data?.entity ?? <VisitingEntity>[];
        visits.sort((VisitingEntity a, VisitingEntity b) =>
            (b.createdAt ?? b.dateTime).compareTo((a.createdAt ?? a.dateTime)));
        return visits.isEmpty
            ? Center(child: Text('no_data_found'.tr()))
            : GridView.builder(
                itemCount: visits.length,
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 6.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ProfileVisitGridviewTile(visit: visits[index]);
                },
              );
      },
    );
  }
}
