import 'package:assecontservices/common/custom_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';



AlterUser(BuildContext context){

  Widget child = Consumer<UserHoleriteManager>(
      builder: (_,user,__){
        return Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(45),
                    topLeft: Radius.circular(45))
            ),
            padding: EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: ()=> Navigator.pop(context),
                        icon: Icon(Icons.clear, color: Colors.blue,)),
                  ],
                ),
                Text('SELECIONE O USUARIO', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.normal,
                  color: context.watch<Config>().darkTemas ? Colors.white : Colors.black,
                  decoration: TextDecoration.none
                ),),
                SizedBox(height: 20,),
                Container(
                  height: 200,
                  child: ListView.builder(
                      itemCount: user.listuser?.length ?? 0,
                      itemBuilder: (context, index){
                        return InkWell(
                          child: Card(elevation: 0.2,
                            child: ListTile(
                              leading: Icon(CupertinoIcons.person_crop_circle, size: 40,
                                color: user.listuser![index] == user.user ? Config.corPri : null,),
                              title: Text(
                                user.listuser![index].empresa?.toUpperCase() ?? "",
                                style: TextStyle(fontSize: 16,
                                    color: user.listuser![index] == user.user ? Config.corPri : null
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                softWrap: true, maxLines: 1,
                              ),
                              subtitle: Text('Registro: ' +
                                (user.listuser![index].registro ?? ""),
                                style: TextStyle(fontSize: 13,
                                    color: user.listuser![index] == user.user ? Config.corPri : null),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                softWrap: true, maxLines: 1,
                              ),
                            ),
                          ),
                          onTap: () async {
                            user.user = user.listuser![index];
                            context.read<HoleriteManager>().listcompetencias =
                              await context.read<HoleriteManager>().competencias(user.user);
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