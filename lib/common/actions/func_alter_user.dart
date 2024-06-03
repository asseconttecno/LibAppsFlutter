import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../config.dart';
import '../../controllers/controllers.dart';


alterUser(BuildContext context, Function()? onAlterFunc){
  Widget child = Consumer<UserHoleriteManager>(
      builder: (_,user,__){
        return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(45),
                    topLeft: Radius.circular(45))
            ),
            padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: ()=> Navigator.pop(context),
                        icon: const Icon(Icons.clear, color: Colors.blue,)),
                  ],
                ),
                CustomText.text('SELECIONE O USUARIO', style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal,
                    color: context.watch<Config>().darkTemas ? Colors.white : Colors.black,
                    decoration: TextDecoration.none
                ),),
                const SizedBox(height: 20,),
                Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: user.listFunc.length,
                      itemBuilder: (context, index){
                        return InkWell(
                            child: Card(
                              elevation: 0.2,
                              child: ListTile(
                                leading: Icon(CupertinoIcons.person_crop_circle, size: 40,
                                  color: user.listFunc[index] == UserHoleriteManager.funcSelect
                                      ? Config.corPri : null,),
                                title: CustomText.text(
                                  user.listFunc[index].attributes?.nome?.toUpperCase() ?? "",
                                  style: TextStyle(fontSize: 16,
                                      color: user.listFunc[index] == UserHoleriteManager.funcSelect
                                          ? Config.corPri : null
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  softWrap: true, maxLines: 1,
                                ),
                                subtitle: CustomText.text(user.listFunc[index].attributes?.reg == null ?
                                    user.listFunc[index].attributes?.office ?? ""
                                    : 'Registro: ${user.listFunc[index].attributes?.reg ?? ""}',
                                  style: TextStyle(fontSize: 13,
                                      color: user.listFunc[index] == UserHoleriteManager.funcSelect
                                          ? Config.corPri : null),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  softWrap: true, maxLines: 1,
                                ),
                              ),
                            ),
                            onTap: () async {
                              UserHoleriteManager.funcSelect = user.listFunc[index];
                              if(onAlterFunc != null) await onAlterFunc();
                              Navigator.pop(context);
                            }
                        );
                      },
                    )
                )
              ],
            )
        );
      }
  );

  return CustomBottomSheet(context, child, false);
}