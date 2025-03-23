import 'package:flutter/material.dart';
import '../../../../business/core/domain/entity/service/service_entity.dart';
import '../../../post/domain/entities/post_entity.dart';
import 'subwidgets/employee_dropdown.dart';
class BookViewProductDetail extends StatelessWidget {
  const BookViewProductDetail({
    required this.texttheme,
    this.post,
    super.key,
    this.service,
  });

  final PostEntity? post;
  final ServiceEntity? service;
  final TextTheme texttheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(
            width: double.infinity,
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      post?.title ?? service?.name ?? 'null',
                      style: texttheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${post?.price.toString() ?? service?.price.toString() ?? 'null'}',
                    maxLines: 1,
                  )
                ],
              ),
              if (service != null) const Divider(),
              if (service != null)
                EmployeeDropdown(employeesID: service!.employeesID)
            ],
          ),
        ],
      ),
    );
  }
}
