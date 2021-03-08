import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/filter_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/filter.dart';
import '../models/market.dart';


class FilterWidget extends StatefulWidget {
  final ValueChanged<Filter> onFilter;
  

  FilterWidget({Key key, this.onFilter}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends StateMVC<FilterWidget> {

  int index_1 = 1 ;
  int index_2 = 2 ;

  FilterController _con;

  _FilterWidgetState() : super(FilterController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).filter),
                  MaterialButton(
                    onPressed: () {
                      _con.clearFilter();
                    },
                    child: Text(
                      S.of(context).clear,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                primary: true,
                shrinkWrap: true,
                children: <Widget>[
                  // ExpansionTile(
                  //   title: Text(S.of(context).delivery_or_pickup),
                  //   children: [
                  //     CheckboxListTile(
                  //       controlAffinity: ListTileControlAffinity.trailing,
                  //       value: _con.filter?.delivery ?? false,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _con.filter?.delivery = true;
                  //         });
                  //       },
                  //       title: Text(
                  //         S.of(context).delivery,
                  //         overflow: TextOverflow.fade,
                  //         softWrap: false,
                  //         maxLines: 1,
                  //       ),
                  //     ),
                  //     CheckboxListTile(
                  //       controlAffinity: ListTileControlAffinity.trailing,
                  //       value: _con.filter?.delivery ?? false ? false : true,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _con.filter?.delivery = false;
                  //         });
                  //       },
                  //       title: Text(
                  //         S.of(context).pickup,
                  //         overflow: TextOverflow.fade,
                  //         softWrap: false,
                  //         maxLines: 1,
                  //       ),
                  //     ),
                  //   ],
                  //   initiallyExpanded: true,
                  // ),

                  //---------------------------------------------------------------------------------

                  // ExpansionTile(
                  //   title: Text(S.of(context).opened_markets),
                  //   children: [
                  //     CheckboxListTile(
                  //       controlAffinity: ListTileControlAffinity.trailing,
                  //       value: _con.filter?.open ?? false,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _con.filter?.open = value;
                  //         });
                  //       },
                  //       title: Text(
                  //         S.of(context).open,
                  //         overflow: TextOverflow.fade,
                  //         softWrap: false,
                  //         maxLines: 1,
                  //       ),
                  //     ),
                  //   ],
                  //   initiallyExpanded: true,
                  // ),
                  _con.fields.isEmpty
                      ? CircularLoadingWidget(height: 100)
                      : ExpansionTile(
                          title: Text(S.of(context).fields),
                          //children: List.generate(2, (index) {
                           
                          //     children: [
                          //       CheckboxListTile(
                          //         controlAffinity: ListTileControlAffinity.trailing,
                          //         value: _con.fields.elementAt(0).selected,
                          //         onChanged: (value) {
                          //           _con.onChangeFieldsFilter(0);
                                    
                          //         },
                          //         title: Text(
                          //          _con.fields.elementAt(0).name,
                          //           overflow: TextOverflow.fade,
                          //           softWrap: false,
                          //           maxLines: 1,
                          //         ),
                                  
                          //       ),

                          //       CheckboxListTile(
                          //         controlAffinity: ListTileControlAffinity.trailing,
                          //         value: _con.fields.elementAt(1).selected,
                          //         onChanged: (value) {
                          //           _con.onChangeFieldsFilter(1);
                                    
                          //         },
                          //         title: Text(
                          //          S.of(context).beauty_product,
                          //           overflow: TextOverflow.fade,
                          //           softWrap: false,
                          //           maxLines: 1,
                          //         ),
                                  
                          //       ),

                          //       CheckboxListTile(
                          //         controlAffinity: ListTileControlAffinity.trailing,
                          //         value: _con.fields.elementAt(2).selected,
                          //         onChanged: (value) {
                          //           _con.onChangeFieldsFilter(2);
                          //         },
                          //         title: Text(
                          //           S.of(context).services,
                          //           overflow: TextOverflow.fade,
                          //           softWrap: false,
                          //           maxLines: 1,
                          //         ),
                          //       ),
                                

                          //     ],
                          
                          //         initiallyExpanded: true,

                          // ),

                          children: List.generate(_con.fields.length, (index) {
                            print('-----index $index ----');
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: _con.fields.elementAt(index).selected,
                              onChanged: (value) {
                                _con.onChangeFieldsFilter(index);
                                
                              },
                              title: Text(
                                _con.fields.elementAt(index).name,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                maxLines: 1,
                              ),
                            );
                          }),
                          initiallyExpanded: true,
                        ),

            
                ],
              ),
            ),
            SizedBox(height: 15),
            FlatButton(
              onPressed: () {
                _con.saveFilter().whenComplete(() {
                  widget.onFilter(_con.filter);
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              child: Text(
                S.of(context).apply_filters,
                textAlign: TextAlign.start,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
