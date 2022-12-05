import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../config.dart';
import '../../controllers/controllers.dart';


alterEmpresa(BuildContext context){
  Widget child = Consumer<UserAssewebManager>(
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
                CustomText.text('SELECIONE A EMPRESA', style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal,
                    color: context.watch<Config>().darkTemas ? Colors.white : Colors.black,
                    decoration: TextDecoration.none
                ),),
                const SizedBox(height: 20,),
                Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: user.user?.login?.companies?.length ?? 0,
                      itemBuilder: (context, index){
                        return InkWell(
                            child: Card(elevation: 0.2,
                              child: ListTile(
                                leading: Icon(CupertinoIcons.person_crop_circle, size: 40,
                                  color: user.user?.login?.companies![index] == user.companies
                                      ? Config.corPri : null,),
                                title: CustomText.text(
                                  user.user?.login?.companies![index].name?.toUpperCase() ?? "",
                                  style: TextStyle(fontSize: 16,
                                      color: user.user?.login?.companies![index] == user.companies
                                          ? Config.corPri : null
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  softWrap: true, maxLines: 1,
                                ),
                                subtitle: CustomText.text(user.user?.login?.companies![index].cnpj ?? "",
                                  style: TextStyle(fontSize: 13,
                                      color: user.user?.login?.companies![index] == user.companies
                                          ? Config.corPri : null),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  softWrap: true, maxLines: 1,
                                ),
                              ),
                            ),
                            onTap: () async {
                              user.companies = user.user?.login?.companies![index];
                              await context.read<HomeAssewebManager>().getObrigacoesusuarios();
                              await context.read<HomeAssewebManager>().getContatos();
                              //Navigator.pop(context);
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