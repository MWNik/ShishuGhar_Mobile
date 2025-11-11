

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';

import '../../../database/database_helper.dart';
import '../../../database/helper/anthromentory/child_growth_response_helper.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../utils/validate.dart';


class DashboardReportHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<String> location=['partner_id','state_id','district_id','block_id','gp_id','village_id'];
  List<String> crecheItems=['creche_opening_date','creche_status_id'];




  Future<List<Map<String, dynamic>>> excuteCrecheCount({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    print('current date ${filterDate}');
    var db=await databaseHelper.openDb();
   String whereColue= crecheWhereCondition(stateId,  districtId,
       blockId,  gpId, villageId, crecheId,  phase,
       partnerId,  crecheStatus,filterDate,1);
    var query=crecheDataQuery();
    var finalQuery='$query $whereColue';
    print('result $finalQuery');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    // var count=result.length ?? 0;
    return result;
  }

  Future<List<Map<String, dynamic>>> excuteCurrentActiveChildren({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    print('current date ${filterDate}');
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var crecheQuery=crecheDataQuery();
    var enrolled_child='''SELECT 
               *,
                CASE
                WHEN INSTR(responces, 'date_of_enrollment":"') > 0
                  THEN SUBSTR(
                         responces,
                    INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"'),
                 INSTR(
         SUBSTR(
          responces,
             INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"')
          ),
                       '","'
               ) - 1
              )
            ELSE NULL
              END AS date_of_enrollment
              FROM enrollred_exit_child_responce''';


    var enrollMentDate ="'$filterDate'";
    var finalQuery='$crecheQuery  as creche INNER join ($enrolled_child) as childs on childs.creche_id=creche.name $whereColue and (childs.date_of_exit is null or childs.date_of_exit >$enrollMentDate) and childs.date_of_enrollment <=$enrollMentDate';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    // var count=result.length ?? 0;
    return result;
  }

  Future<List<Map<String, dynamic>>> excuteNoOfCrecheNotSubmitedAttendence({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
    async {
      print('current date ${filterDate}');
      var db=await databaseHelper.openDb();
      String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
          blockId,  gpId, villageId, crecheId,  phase,
          partnerId,  crecheStatus,filterDate);
      var enrollMentDate ="'$filterDate'";
      var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
      var monthYear ="'${Global.getMonthYearByDate(filterDate)}'";
      var eligibleCondition ="and  creche.elgdays > IFNULL(attenDays.atteneDays, 0)";
      var eligbleDays='''SELECT 
    creche.*,
    IFNULL(attenDays.atteneDays, 0) AS atteneDays
FROM (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'phase":"') + LENGTH('phase":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'phase":"') + LENGTH('phase":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS phase, responces as crecheData,

     
        CAST(
            (
                JULIANDAY(
                    CASE 
                        WHEN strftime('%Y-%m', 'now') = $monthYear 
                        THEN date('now') 
                        ELSE $enrollMentDate
                    END
                ) 
                - JULIANDAY(
                    CASE 
                        WHEN date(
                            CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
                                THEN SUBSTR(
                                    responces,
                                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
                                    INSTR(
                                        SUBSTR(
                                            responces,
                                            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                                        ),
                                        '","'
                                    ) - 1
                                )
                            ELSE NULL END
                        ) < date($startDate)
                        THEN date($startDate)
                        ELSE date(
                            CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
                                THEN SUBSTR(
                                    responces,
                                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
                                    INSTR(
                                        SUBSTR(
                                            responces,
                                            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                                        ),
                                        '","'
                                    ) - 1
                                )
                            ELSE NULL END
                        )
                    END
                )
            ) + 1 AS INTEGER
        ) AS elgdays

    FROM  ${eligbleCrecheQuery()} 
) creche
LEFT JOIN (
    SELECT COUNT(*) AS atteneDays, creche_id 
    FROM child_attendance_responce
    WHERE date_of_attendance BETWEEN $startDate and $enrollMentDate
    GROUP BY creche_id
) attenDays 
    ON attenDays.creche_id = creche.name''';




      var finalQuery='$eligbleDays $whereColue $eligibleCondition';
      print('query ${finalQuery}');
      List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
      print('result $result');
      // var count=result.length ?? 0;
      return result;
  }

  Future<List<Map<String, dynamic>>> excuteNoOfCrecheSubmitedAttendence({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    print('current date ${filterDate}');
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var monthYear ="'${Global.getMonthYearByDate(filterDate)}'";
    var eligibleCondition ="and  creche.elgdays <= IFNULL(attenDays.atteneDays, 0)";
    var eligbleDays='''SELECT 
    creche.*,
    IFNULL(attenDays.atteneDays, 0) AS atteneDays
FROM (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
            THEN SUBSTR(
                responces,
                INSTR(responces, 'phase":"') + LENGTH('phase":"'),
                INSTR(
                    SUBSTR(
                        responces,
                        INSTR(responces, 'phase":"') + LENGTH('phase":"')
                    ),
                    '","'
                ) - 1
            ) ELSE NULL END AS phase,responces as crecheData,

     
        CAST(
            (
                JULIANDAY(
                    CASE 
                        WHEN strftime('%Y-%m', 'now') = $monthYear 
                        THEN date('now') 
                        ELSE $enrollMentDate
                    END
                ) 
                - JULIANDAY(
                    CASE 
                        WHEN date(
                            CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
                                THEN SUBSTR(
                                    responces,
                                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
                                    INSTR(
                                        SUBSTR(
                                            responces,
                                            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                                        ),
                                        '","'
                                    ) - 1
                                )
                            ELSE NULL END
                        ) < date($startDate)
                        THEN date($startDate)
                        ELSE date(
                            CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
                                THEN SUBSTR(
                                    responces,
                                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
                                    INSTR(
                                        SUBSTR(
                                            responces,
                                            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                                        ),
                                        '","'
                                    ) - 1
                                )
                            ELSE NULL END
                        )
                    END
                )
            ) + 1 AS INTEGER
        ) AS elgdays

    FROM  ${eligbleCrecheQuery()} 
) creche
LEFT JOIN (
    SELECT COUNT(*) AS atteneDays, creche_id 
    FROM child_attendance_responce
    WHERE date_of_attendance BETWEEN $startDate and $enrollMentDate
    GROUP BY creche_id
) attenDays 
    ON attenDays.creche_id = creche.name''';




    var finalQuery='$eligbleDays $whereColue $eligibleCondition';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    // var count=result.length ?? 0;
    return result;
  }

  Future<List<Map<String, dynamic>>> excuteEnrolldCildThisMonth({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    print('current date ${filterDate}');
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var crecheQuery=crecheDataQuery();
    var enrolled_child='''SELECT 
               *,
                CASE
                WHEN INSTR(responces, 'date_of_enrollment":"') > 0
                  THEN SUBSTR(
                         responces,
                    INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"'),
                 INSTR(
         SUBSTR(
          responces,
             INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"')
          ),
                       '","'
               ) - 1
              )
            ELSE NULL
              END AS date_of_enrollment
              FROM enrollred_exit_child_responce''';


    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var finalQuery='$crecheQuery  as creche INNER join ($enrolled_child) as childs on childs.creche_id=creche.name $whereColue  and childs.date_of_enrollment  BETWEEN $startDate and $enrollMentDate';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    // var count=result.length ?? 0;
    return result;
  }

  Future<List<Map<String, dynamic>>> excuteExitCildThisMonth({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    print('current date ${filterDate}');
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var crecheQuery=crecheDataQuery();
    var enrolled_child='''SELECT 
               *,
                CASE
                WHEN INSTR(responces, 'date_of_enrollment":"') > 0
                  THEN SUBSTR(
                         responces,
                    INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"'),
                 INSTR(
         SUBSTR(
          responces,
             INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"')
          ),
                       '","'
               ) - 1
              )
            ELSE NULL
              END AS date_of_enrollment
              FROM enrollred_exit_child_responce''';


    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var finalQuery='$crecheQuery  as creche INNER join ($enrolled_child) as childs on childs.creche_id=creche.name $whereColue  and childs.date_of_exit  BETWEEN $startDate and $enrollMentDate';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    var count=result.length ?? 0;
    return result;
  }


  Future<int> excuteMaximumAttendanceADay({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    print('current date ${filterDate}');
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,0);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var childAttendE='group by date_of_attendance)';
    var childAttendJoin='''select max (maxAtn) as mxAtCount from (Select sum (presentCount) as maxAtn from(select * from ( SELECT  
        attendance.creche_id,
        attendance.childattenguid,presentCount,
    CASE 
        WHEN INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":')
                ),
                ',"'
            ) - 1
        ) 
        ELSE NULL 
    END AS is_shishu_ghar_is_closed_for_the_day,date_of_attendance
    FROM child_attendance_responce attendance
     join (
        SELECT   
            childattenguid, COUNT(childattenguid) AS presentCount
        FROM child_attendence  
        WHERE attendance = 1 group by childattenguid
    ) AS child_att   
        ON child_att.childattenguid = attendance.childattenguid where 
		 is_shishu_ghar_is_closed_for_the_day='0' 
		 and date_of_attendance BETWEEN $startDate and $enrollMentDate)  childAttence
		 left join (
		SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase ,responces as crecheData

    FROM  ${eligbleCrecheQuery()}  
)  creche  
on creche.name=childAttence.creche_id) ''';



    var finalQuery='$childAttendJoin $whereColue $childAttendE ';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    var count=result.length ?? 0;
    if(count>0){
      count=Global.validToInt(result.first['mxAtCount']);
    }
    return count;
  }

  Future<List<Map<String, dynamic>>> excuteCurrentEligibleChild({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String finalDateValue=filterDate!;
    var finalDate=Global.isCurrentMonth(filterDate);
    if(finalDate){
      finalDateValue=Validate().currentDate();
    }
    String whereColue= crecheWhereWithJoinCondition( stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,finalDateValue);
    var crecheQuery=crecheDataQuery();

    var minus36MonthBack=Global.subtractMonths(finalDateValue,36);
    var minus6MonthBack=Global.subtractMonths(finalDateValue,6);
    var childBeetween='''and DATE(children.child_dob) BETWEEN 
        DATE('$minus36MonthBack')
        AND  DATE('$minus6MonthBack')''';
    var hhChildren='''creche left join 
(SELECT 
    children.*,
    hh.creche_id AS crecheId, enrollreChild.responces as enrolledChildResponce,

    CASE 
        WHEN INSTR(children.responces, 'is_dob_available":') > 0 
        THEN SUBSTR(
            children.responces,
            INSTR(children.responces, 'is_dob_available":') + LENGTH('is_dob_available":'),
            INSTR(
                SUBSTR(
                    children.responces,
                    INSTR(children.responces, 'is_dob_available":') + LENGTH('is_dob_available":')
                ),
                ',"'
            ) - 1
        ) 
        ELSE NULL 
    END AS is_dob_available,
	CASE 
    WHEN INSTR(children.responces, '"child_status":') > 0 
    THEN 
        CASE 
            WHEN INSTR(
                SUBSTR(
                    children.responces,
                    INSTR(children.responces, '"child_status":') + LENGTH('"child_status":')
                ),
                'null'
            ) = 1 THEN NULL
            
            WHEN INSTR(
                SUBSTR(
                    children.responces,
                    INSTR(children.responces, '"child_status":') + LENGTH('"child_status":')
                ),
                '""'
            ) = 1 THEN NULL
            
            ELSE SUBSTR(
                children.responces,
                INSTR(children.responces, '"child_status":') + LENGTH('"child_status":'),
                INSTR(
                    SUBSTR(
                        children.responces,
                        INSTR(children.responces, '"child_status":') + LENGTH('"child_status":')
                    ),
                    ',"'
                ) - 1
            )
        END
    ELSE NULL 
END AS child_status,
    CASE 
        WHEN INSTR(children.responces, 'child_dob":"') > 0 
        THEN SUBSTR(
            children.responces,
            INSTR(children.responces, 'child_dob":"') + LENGTH('child_dob":"'),
            INSTR(
                SUBSTR(
                    children.responces,
                    INSTR(children.responces, 'child_dob":"') + LENGTH('child_dob":"')
                ),
                '","'
            ) - 1
        ) 
        ELSE NULL 
    END AS child_dob

FROM house_hold_children children
LEFT JOIN house_hold_responce AS hh 
    ON children.HHGUID = hh.HHGUID  
left join (select CHHGUID,responces  from enrollred_exit_child_responce group by CHHGUID)
 as enrollreChild on children.CHHGUID=enrollreChild.CHHGUID
WHERE 
    is_dob_available = '1'  and child_status ISNULL  ) as children  on children.crecheId=creche.name''';



    var finalQuery='$crecheQuery  $hhChildren  $whereColue $childBeetween ';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    var count=result.length ?? 0;
    return result;
  }



  Future<List<Map<String, dynamic>>> excuteCurrentEligibleButNotEnrlolledChild({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String finalDateValue=filterDate!;
    var finalDate=Global.isCurrentMonth(filterDate);
    if(finalDate){
      finalDateValue=Validate().currentDate();
    }
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,finalDateValue);
    var crecheQuery=crecheDataQuery();

    var minus36MonthBack=Global.subtractMonths(finalDateValue,36);
    var minus6MonthBack=Global.subtractMonths(finalDateValue,6);
    var childEnrlled='''and children.CHHGUID not in  (select CHHGUID from enrollred_exit_child_responce where ChildEnrollGUID NOT in ( select ChildEnrollGUID  from enrollred_exit_child_responce
    where date_of_exit < '$finalDateValue'))''';
    var childBeetween='''and DATE(children.child_dob) BETWEEN 
        DATE('$minus36MonthBack')
        AND  DATE('$minus6MonthBack')''';
    var hhChildren='''creche left join 
(SELECT 
    children.*,
    hh.creche_id AS crecheId, enrollreChild.responces as enrolledChildResponce,

    CASE 
        WHEN INSTR(children.responces, 'is_dob_available":') > 0 
        THEN SUBSTR(
            children.responces,
            INSTR(children.responces, 'is_dob_available":') + LENGTH('is_dob_available":'),
            INSTR(
                SUBSTR(
                    children.responces,
                    INSTR(children.responces, 'is_dob_available":') + LENGTH('is_dob_available":')
                ),
                ',"'
            ) - 1
        ) 
        ELSE NULL 
    END AS is_dob_available,
	CASE 
    WHEN INSTR(children.responces, '"child_status":') > 0 
    THEN 
        CASE 
            WHEN INSTR(
                SUBSTR(
                    children.responces,
                    INSTR(children.responces, '"child_status":') + LENGTH('"child_status":')
                ),
                'null'
            ) = 1 THEN NULL
            
            WHEN INSTR(
                SUBSTR(
                    children.responces,
                    INSTR(children.responces, '"child_status":') + LENGTH('"child_status":')
                ),
                '""'
            ) = 1 THEN NULL
            
            ELSE SUBSTR(
                children.responces,
                INSTR(children.responces, '"child_status":') + LENGTH('"child_status":'),
                INSTR(
                    SUBSTR(
                        children.responces,
                        INSTR(children.responces, '"child_status":') + LENGTH('"child_status":')
                    ),
                    ',"'
                ) - 1
            )
        END
    ELSE NULL 
END AS child_status,
    CASE 
        WHEN INSTR(children.responces, 'child_dob":"') > 0 
        THEN SUBSTR(
            children.responces,
            INSTR(children.responces, 'child_dob":"') + LENGTH('child_dob":"'),
            INSTR(
                SUBSTR(
                    children.responces,
                    INSTR(children.responces, 'child_dob":"') + LENGTH('child_dob":"')
                ),
                '","'
            ) - 1
        ) 
        ELSE NULL 
    END AS child_dob

FROM house_hold_children children
LEFT JOIN house_hold_responce AS hh 
    ON children.HHGUID = hh.HHGUID  
left join (select CHHGUID,responces  from enrollred_exit_child_responce group by CHHGUID)
 as enrollreChild on children.CHHGUID=enrollreChild.CHHGUID
WHERE 
    is_dob_available = '1'  and child_status ISNULL  ) as children  on children.crecheId=creche.name''';



    var finalQuery='$crecheQuery  $hhChildren  $whereColue $childBeetween $childEnrlled';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    var count=result.length ?? 0;
    return result;
  }



  Future<List<Map<String, dynamic>>> excuteCumulativeEnrolledChild({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var crecheQuery=crecheDataQuery();
    var enrollMentDate ="'$filterDate'";
    var exitedChild='''creche
	inner join (select *,CASE WHEN INSTR(responces, 'date_of_enrollment":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS date_of_enrollment from enrollred_exit_child_responce where date_of_enrollment <= $enrollMentDate) 
	extedChild  on extedChild.creche_id=creche.name''';



    var finalQuery='$crecheQuery  $exitedChild  $whereColue';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    var count=result.length ?? 0;
    return result;
  }

  Future<List<Map<String, dynamic>>> excuteCumulativeExitChild({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var crecheQuery=crecheDataQuery();
    var enrollMentDate ="'$filterDate'";
    var exitedChild='''creche
	inner join (select * from enrollred_exit_child_responce where date_of_exit <= $enrollMentDate) 
	extedChild  on extedChild.creche_id=creche.name''';



    var finalQuery='$crecheQuery  $exitedChild  $whereColue';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    var count=result.length ?? 0;
    return result;
  }

  Future<int> excuteAvgNoOfDaysCrecheOpenedChild({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var crechCount=await excuteCrecheCount(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);

    var crecheQuery=crecheDataForJoinQuery();
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var startQury ="Select IFNULL(COUNT(*), 0) AS total_count ";
    var betWeen ="and date_of_attendance BETWEEN $startDate and $enrollMentDate";
    var avgOpenDayCount='''creche	INNER join (
select * ,CASE 
        WHEN INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":')
                ),
                ',"'
            ) - 1
        ) 
        ELSE NULL 
    END AS is_shishu_ghar_is_closed_for_the_day from child_attendance_responce where is_shishu_ghar_is_closed_for_the_day='0') as childAttendence
on childAttendence.creche_id=creche.name''';



    var finalQuery='$startQury $crecheQuery $avgOpenDayCount  $whereColue $betWeen';
    print('query ${finalQuery}');
    List<Map<String, dynamic>> result = await db.rawQuery(finalQuery);
    print('result $result');
    var count=result.length ?? 0;
    if(count>0&&crechCount.length>0){
      count=result.first['total_count'];
      count=(Global.validToInt(count)/crechCount.length).ceil();
    }
    return count;
  }

 Future<double> excuteAvgAttendancePerDay({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);

    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var no_children_present_creche_opened ='''SELECT *
             FROM (select * from child_attendence where attendance=1) cal
             JOIN (select *, CASE 
        WHEN INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":')
                ),
                ',"'
            ) - 1
        ) 
        ELSE NULL 
    END AS is_shishu_ghar_is_closed_for_the_day from child_attendance_responce where is_shishu_ghar_is_closed_for_the_day='0') childAttendence ON childAttendence.childattenguid = cal.childattenguid
			JOIN (SELECT 
        name,

        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  ) creche ON creche.name = childAttendence.creche_id
''';
    var no_days_creche_opened ='''SELECT  * from (Select *, CASE 
        WHEN INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":')
                ),
                ',"'
            ) - 1
        ) 
        ELSE NULL 
    END AS is_shishu_ghar_is_closed_for_the_day from child_attendance_responce where is_shishu_ghar_is_closed_for_the_day='0') childAttendence 
			JOIN (SELECT 
        name,

        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  ) creche ON creche.name = childAttendence.creche_id
''';
    var betWeen ="and childAttendence. date_of_attendance BETWEEN $startDate and $enrollMentDate";



    var no_children_present_creche_openedQuery='$no_children_present_creche_opened  $whereColue $betWeen';
    var no_days_creche_openedQuery='$no_days_creche_opened  $whereColue $betWeen';
    List<Map<String, dynamic>> no_children_present_creche_openedResult = await db.rawQuery(no_children_present_creche_openedQuery);
    List<Map<String, dynamic>> no_days_creche_openedResult = await db.rawQuery(no_days_creche_openedQuery);
    var no_children_present_creche_openedCount=no_children_present_creche_openedResult.length ?? 0;
    var no_days_creche_openedCount=no_days_creche_openedResult.length ?? 0;
    var count=0.0;
    if(no_children_present_creche_openedCount>0&&no_days_creche_openedCount>0){
      count=no_children_present_creche_openedCount/no_days_creche_openedCount;
      count = double.parse(count.toStringAsFixed(1));
    }
    return count;
  }


  Future<int> excuteDaysAttendanceSubmitted({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var crechCount=await excuteCrecheCount(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var No_of_days_creche_attendance_submitted ='''SELECT  * from (Select *, CASE 
        WHEN INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'is_shishu_ghar_is_closed_for_the_day":') + LENGTH('is_shishu_ghar_is_closed_for_the_day":')
                ),
                ',"'
            ) - 1
        ) 
        ELSE NULL 
    END AS is_shishu_ghar_is_closed_for_the_day from child_attendance_responce ) childAttendence 
			JOIN (SELECT 
        name,

        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  ) creche ON creche.name = childAttendence.creche_id
''';
    var betWeen ="and childAttendence. date_of_attendance BETWEEN $startDate and $enrollMentDate";



    var no_children_present_creche_openedQuery='$No_of_days_creche_attendance_submitted  $whereColue $betWeen';
    List<Map<String, dynamic>> no_children_present_creche_openedResult = await db.rawQuery(no_children_present_creche_openedQuery);
    var no_children_present_creche_openedCount=no_children_present_creche_openedResult.length ?? 0;
    var count=0;
    if(no_children_present_creche_openedCount>0&&crechCount.length>0){
      count=(no_children_present_creche_openedCount/crechCount.length).ceil();
    }
    return count;
  }


  Future<List<Map<String, dynamic>>> excuteAnthroDataNotSubmitted({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,1);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var crecheQuery =crecheDataQuery();
    var anthroQuery ='''and name NOT IN ( SELECT creche_id FROM child_anthormentry_responce 
         WHERE measurement_date BETWEEN $startDate AND $enrollMentDate
    )''';



    var antroDataNotSubmited='$crecheQuery  $whereColue $anthroQuery';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
     var count=result.length ?? 0;
    return result;
  }

  Future<List<Map<String, dynamic>>> excuteAnthroDataSubmitted({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,1);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var crecheQuery =crecheDataQuery();
    var anthroQuery ='''and name  IN ( SELECT creche_id FROM child_anthormentry_responce 
         WHERE measurement_date BETWEEN $startDate AND $enrollMentDate
    )''';



    var antroDataNotSubmited='$crecheQuery  $whereColue $anthroQuery';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
    var count=result.length ?? 0;
    return result;
  }


Future<List<Map<String, dynamic>>> excuteChildrenMeasermentTaken({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,0);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var anthroQuery ='''Select * from (SELECT * from (select * 
    FROM child_anthormentry_responce  WHERE measurement_date BETWEEN $startDate AND $enrollMentDate) anthro
left join (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  
) creche  on creche.name=anthro.creche_id
    ''';



    var antroDataSubmited='$anthroQuery  $whereColue )';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataSubmited);
    List<Map<String, dynamic>> allChildren=[];
    for (int i = 0; i < result.length; i++) {
      var responceItem=result[i]['responces'];
      Map<String, dynamic> responseData = jsonDecode(responceItem);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
            responseData['anthropromatic_details']);
        var itemChildren=children
            .where((element) => element['do_you_have_height_weight'].toString() ==
            '1')
            .toList();
        allChildren.addAll(itemChildren);
    }}
    return allChildren;
  }

  Future<List<Map<String, dynamic>>> excuteGetChildrenByGUIDES({
    String? childIdes,
  })
  async {
    var db=await databaseHelper.openDb();
    var childQuery='''select childs.*,creche.responces as crecheData from enrollred_exit_child_responce  childs
  left join tab_creche_response as creche on childs.creche_id=creche.name
  where ChildEnrollGUID in  ($childIdes)''';
    var antroDataNotSubmited='$childQuery';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);

    return result;
  }



  Future<List<Map<String, dynamic>>> excuteChildrenMeasermentNotTaken({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereWithJoinCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate);
    var enrollMentDate ="'$filterDate'";
    var crecheQuery=crecheDataQuery();

    var anthroQuery ='''creche  inner join (
select *,CASE WHEN INSTR(responces, 'date_of_enrollment":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'date_of_enrollment":"') + LENGTH('date_of_enrollment":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS date_of_enrollment from enrollred_exit_child_responce
		where date_of_enrollment<=$enrollMentDate
		and (date_of_exit IS NULL OR date_of_exit > $enrollMentDate)  )  as enrolledChild
		on enrolledChild.creche_id=creche.name  
    ''';
    var childrenMeasurementTaken  = await DashboardReportHelper().excuteChildrenMeasermentTaken(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);
    var submitedId='';
    for (int i = 0; i < childrenMeasurementTaken.length; i++) {
      if(Global.validString(submitedId)){
        submitedId="$submitedId,'${childrenMeasurementTaken[i]['childenrollguid']}'";
      }else submitedId="'${childrenMeasurementTaken[i]['childenrollguid']}'";
    }

    var submitedChild ="and enrolledChild.ChildEnrollGUID not in ($submitedId)";

    var antroDataNotSubmited='$crecheQuery $anthroQuery  $whereColue $submitedChild';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
    return result;
  }

  // Severely underweight
  Future<List<Map<String, dynamic>>> excuteSeverUnderWeight({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,0);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var anthroQuery ='''Select * from (SELECT * from (select * 
    FROM child_anthormentry_responce  WHERE measurement_date BETWEEN $startDate AND $enrollMentDate) anthro
left join (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  
) creche  on creche.name=anthro.creche_id) 
    ''';



    var antroDataNotSubmited='$anthroQuery  $whereColue';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
    List<Map<String, dynamic>> allChildren=[];
    for (int i = 0; i < result.length; i++) {
      var responceItem=result[i]['responces'];
      Map<String, dynamic> responseData = jsonDecode(responceItem);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
            responseData['anthropromatic_details']);
        var itemChildren=children
            .where((element) => element['do_you_have_height_weight'].toString() ==
            '1'&& Global.stringToDouble(element['weight_for_age'].toString()) ==
            1)
            .toList();
        allChildren.addAll(itemChildren);
      }}

    var count=allChildren.length ?? 0;
    return allChildren;
  }

  // Severely stunted
Future<List<Map<String, dynamic>>> excuteSeverelyStunted({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,0);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var anthroQuery ='''Select * from (SELECT * from (select * 
    FROM child_anthormentry_responce  WHERE measurement_date BETWEEN $startDate AND $enrollMentDate) anthro
left join (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  
) creche  on creche.name=anthro.creche_id) 
    ''';



    var antroDataNotSubmited='$anthroQuery  $whereColue';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
    List<Map<String, dynamic>> allChildren=[];
    for (int i = 0; i < result.length; i++) {
      var responceItem=result[i]['responces'];
      Map<String, dynamic> responseData = jsonDecode(responceItem);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
            responseData['anthropromatic_details']);
        var itemChildren=children
            .where((element) => element['do_you_have_height_weight'].toString() ==
            '1'&& Global.stringToDouble(element['height_for_age'].toString()) ==
            1)
            .toList();
        allChildren.addAll(itemChildren);
      }}
    var count=allChildren.length ?? 0;
    return allChildren;
  }

// Severely wasted
Future< List<Map<String, dynamic>>> excuteSeverelyWasted({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,0);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var anthroQuery ='''Select * from (SELECT * from (select * 
    FROM child_anthormentry_responce  WHERE measurement_date BETWEEN $startDate AND $enrollMentDate) anthro
left join (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  
) creche  on creche.name=anthro.creche_id) 
    ''';



    var antroDataNotSubmited='$anthroQuery  $whereColue';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
    List<Map<String, dynamic>> allChildren=[];
    for (int i = 0; i < result.length; i++) {
      var responceItem=result[i]['responces'];
      Map<String, dynamic> responseData = jsonDecode(responceItem);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
            responseData['anthropromatic_details']);
        var itemChildren=children
            .where((element) => element['do_you_have_height_weight'].toString() ==
            '1'&& Global.stringToDouble(element['weight_for_height'].toString()) ==
            1)
            .toList();
        allChildren.addAll(itemChildren);
      }}
    var count=allChildren.length ?? 0;
    return allChildren;
  }

  // Moderately underweight
  Future< List<Map<String, dynamic>>> excuteModerateUnderWeight({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,0);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var anthroQuery ='''Select * from (SELECT * from (select * 
    FROM child_anthormentry_responce  WHERE measurement_date BETWEEN $startDate AND $enrollMentDate) anthro
left join (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  
) creche  on creche.name=anthro.creche_id) 
    ''';



    var antroDataNotSubmited='$anthroQuery  $whereColue';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
    List<Map<String, dynamic>> allChildren=[];
    for (int i = 0; i < result.length; i++) {
      var responceItem=result[i]['responces'];
      Map<String, dynamic> responseData = jsonDecode(responceItem);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
            responseData['anthropromatic_details']);
        var itemChildren=children
            .where((element) => element['do_you_have_height_weight'].toString() ==
            '1'&& Global.stringToDouble(element['weight_for_age'].toString()) ==
            2)
            .toList();
        allChildren.addAll(itemChildren);
      }}
    var count=allChildren.length ?? 0;
    return allChildren;
  }


  // Moderately wasted
  Future< List<Map<String, dynamic>>> excuteModerateWastage({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,0);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var anthroQuery ='''Select * from (SELECT * from (select * 
    FROM child_anthormentry_responce  WHERE measurement_date BETWEEN $startDate AND $enrollMentDate) anthro
left join (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  
) creche  on creche.name=anthro.creche_id) 
    ''';



    var antroDataNotSubmited='$anthroQuery  $whereColue';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
    List<Map<String, dynamic>> allChildren=[];
    for (int i = 0; i < result.length; i++) {
      var responceItem=result[i]['responces'];
      Map<String, dynamic> responseData = jsonDecode(responceItem);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
            responseData['anthropromatic_details']);
        var itemChildren=children
            .where((element) => element['do_you_have_height_weight'].toString() ==
            '1'&& Global.stringToDouble(element['weight_for_height'].toString()) ==
            2)
            .toList();
        allChildren.addAll(itemChildren);
      }}
    var count=allChildren.length ?? 0;
    return allChildren;
  }

  // Moderately stunted
  Future< List<Map<String, dynamic>>> excuteModerateStunted({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {
    var db=await databaseHelper.openDb();
    String whereColue= crecheWhereCondition(  stateId,  districtId,
        blockId,  gpId, villageId, crecheId,  phase,
        partnerId,  crecheStatus,filterDate,0);
    var enrollMentDate ="'$filterDate'";
    var startDate ="'${Global.getFirstDayDateByDate(filterDate!)}'";
    var anthroQuery ='''Select * from (SELECT * from (select * 
    FROM child_anthormentry_responce  WHERE measurement_date BETWEEN $startDate AND $enrollMentDate) anthro
left join (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase

    FROM  ${eligbleCrecheQuery()}  
) creche  on creche.name=anthro.creche_id) 
    ''';



    var antroDataNotSubmited='$anthroQuery  $whereColue';
    List<Map<String, dynamic>> result = await db.rawQuery(antroDataNotSubmited);
    List<Map<String, dynamic>> allChildren=[];
    for (int i = 0; i < result.length; i++) {
      var responceItem=result[i]['responces'];
      Map<String, dynamic> responseData = jsonDecode(responceItem);
      var childs = responseData['anthropromatic_details'];
      if (childs != null) {
        List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(
            responseData['anthropromatic_details']);
        var itemChildren=children
            .where((element) => element['do_you_have_height_weight'].toString() ==
            '1'&& Global.stringToDouble(element['height_for_age'].toString()) ==
            2)
            .toList();
        allChildren.addAll(itemChildren);
      }}
    var count=allChildren.length ?? 0;
    return allChildren;
  }

  // GF1
  Future<List<Map<String, dynamic>>> excuteGF1({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {

    List<Map<String, dynamic>> allChildren=[];
    var childrenMeasurementTaken  = await DashboardReportHelper().excuteChildrenMeasermentTaken(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);

    for (int i = 0; i < childrenMeasurementTaken.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkSUWCondition(element['childenrollguid']
            ,element['measurement_taken_date'],element);
        if(gfReco=='GF1'){
          allChildren.add(element);
        }
      }

    }

    return allChildren;
  }

  // GF1 with all anthro
  Future<List<Map<String, dynamic>>> excuteGF1Anthro({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
    List<ChildGrowthMetaResponseModel>? allAntroData
  })
  async {

    List<Map<String, dynamic>> allChildren=[];
    var childrenMeasurementTaken  = await DashboardReportHelper().excuteChildrenMeasermentTaken(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);

    for (int i = 0; i < childrenMeasurementTaken.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkRedFlagGrowthMonitoring(element['childenrollguid']
            ,element['measurement_taken_date'],element['cgmguid'],
            element,allAntroData!);
        if(gfReco=='GF1'){
          allChildren.add(element);
        }
      }

    }

    return allChildren;
  }

  // GF1  with  With Measurement Taken
  Future<List<Map<String, dynamic>>> excuteGF1WithMeasurementTaken({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate
    ,List<Map<String, dynamic>>? childrenMeasurementTaken,
  })
  async {

    List<Map<String, dynamic>> allChildren=[];

    for (int i = 0; i < childrenMeasurementTaken!.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkSUWCondition(element['childenrollguid']
            ,element['measurement_taken_date'],element);
        if(gfReco=='GF1'){
          allChildren.add(element);
        }
      }

    }

    return allChildren;
  }


  // GF1   With Measurement Taken  local
  Future<List<Map<String, dynamic>>> excuteGF1AllAnthro({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,List<Map<String, dynamic>>? childrenMeasurementTaken,
    List<ChildGrowthMetaResponseModel>? allAntroData})
  async {

    List<Map<String, dynamic>> allChildren=[];

    for (int i = 0; i < childrenMeasurementTaken!.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkRedFlagGrowthMonitoring(element['childenrollguid']
            ,element['measurement_taken_date'],element['cgmguid'],
            element,allAntroData!);
        if(gfReco=='GF1'){
          allChildren.add(element);
        }
      }

    }

    return allChildren;
  }

  // GF2
  Future<List<Map<String, dynamic>>> excuteGF2({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {

    List<Map<String, dynamic>> allChildren=[];
    var childrenMeasurementTaken  = await DashboardReportHelper().excuteChildrenMeasermentTaken(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);

    for (int i = 0; i < childrenMeasurementTaken.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
      var gfReco = await checkSUWCondition(element['childenrollguid']
          ,element['measurement_taken_date'],element);
      if(gfReco=='GF2'){
        allChildren.add(element);
      }}
    }

    return allChildren;
  }


  // GF2  with anthro
  Future<List<Map<String, dynamic>>> excuteGF2Antro({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
    List<ChildGrowthMetaResponseModel>? allAntroData
  })
  async {

    List<Map<String, dynamic>> allChildren=[];
    var childrenMeasurementTaken  = await DashboardReportHelper().excuteChildrenMeasermentTaken(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);

    for (int i = 0; i < childrenMeasurementTaken.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkRedFlagGrowthMonitoring(element['childenrollguid']
            ,element['measurement_taken_date'],element['cgmguid'],
            element,allAntroData!);
        if(gfReco=='GF2'){
          allChildren.add(element);
        }}
    }

    return allChildren;
  }

  // GF2   With Measurement Taken  local
  Future<List<Map<String, dynamic>>> excuteGF2MeasurementTakenAllAnthro({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
    List<Map<String, dynamic>>? childrenMeasurementTaken,
    List<ChildGrowthMetaResponseModel>? allAntroData
  })
  async {

    List<Map<String, dynamic>> allChildren=[];

    for (int i = 0; i < childrenMeasurementTaken!.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkRedFlagGrowthMonitoring(element['childenrollguid']
            ,element['measurement_taken_date'],element['cgmguid'],
            element,allAntroData!);
        if(gfReco=='GF2'){
          allChildren.add(element);
        }}
    }

    return allChildren;
  }

  // GF2   With Measurement Taken  with
  Future<List<Map<String, dynamic>>> excuteGF2MeasurementTaken({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
    List<Map<String, dynamic>>? childrenMeasurementTaken,
  })
  async {

    List<Map<String, dynamic>> allChildren=[];

    for (int i = 0; i < childrenMeasurementTaken!.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkSUWCondition(element['childenrollguid']
            ,element['measurement_taken_date'],element);
        if(gfReco=='GF2'){
          allChildren.add(element);
        }}
    }

    return allChildren;
  }

  // Red flag children
  Future<List<Map<String, dynamic>>> excuteRedFlag({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
  })
  async {

    List<Map<String, dynamic>> allChildren=[];
    var childrenMeasurementTaken  = await DashboardReportHelper().excuteChildrenMeasermentTaken(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);

    for (int i = 0; i < childrenMeasurementTaken.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkSUWCondition(element['childenrollguid']
            ,element['measurement_taken_date'],element);

        if (Global.stringToDouble(
            element['weight_for_height'].toString()) ==
            1 ||
            gfReco=='GF2' ||
            Global.stringToInt(
                element['any_medical_major_illness'].toString()) ==
                1 ||
            Global.stringToDouble(element['weight_for_age'].toString()) ==
                1) {
          allChildren.add(element);
        }}
    }

    return allChildren;
  }

  // Red flag children
  Future<List<Map<String, dynamic>>> excuteRedFlagAnthro({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
    List<ChildGrowthMetaResponseModel>? allAntroData
  })
  async {

    List<Map<String, dynamic>> allChildren=[];
    var childrenMeasurementTaken  = await DashboardReportHelper().excuteChildrenMeasermentTaken(stateId: stateId,
        districtId:  districtId,blockId:  blockId, gpId: gpId,   villageId: villageId,  crecheId: crecheId, phase: phase,  partnerId: partnerId,
        crecheStatus: crecheStatus,filterDate:filterDate);

    for (int i = 0; i < childrenMeasurementTaken.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkRedFlagGrowthMonitoring(element['childenrollguid']
            ,element['measurement_taken_date'],element['cgmguid'],
            element,allAntroData!);

        if (Global.stringToDouble(
            element['weight_for_height'].toString()) ==
            1 ||
            gfReco=='GF2' ||
            Global.stringToInt(
                element['any_medical_major_illness'].toString()) ==
                1 ||
            Global.stringToDouble(element['weight_for_age'].toString()) ==
                1) {
          allChildren.add(element);
        }}
    }

    return allChildren;
  }

  // Red flag children  measument taken
  Future<List<Map<String, dynamic>>> excuteRedFlagMeasurmentTaken({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
    List<Map<String, dynamic>>? childrenMeasurementTaken,

  })
  async {

    List<Map<String, dynamic>> allChildren=[];

    for (int i = 0; i < childrenMeasurementTaken!.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkSUWCondition(element['childenrollguid']
            ,element['measurement_taken_date'],element);

        if (Global.stringToDouble(
            element['weight_for_height'].toString()) ==
            1 ||
            gfReco=='GF2' ||
            Global.stringToInt(
                element['any_medical_major_illness'].toString()) ==
                1 ||
            Global.stringToDouble(element['weight_for_age'].toString()) ==
                1) {
          allChildren.add(element);
        }}
    }

    return allChildren;
  }


  // Red flag children  measument taken  all anthro
  Future<List<Map<String, dynamic>>> excuteRedFlagMeasurmentTakenAllAnthro({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
    List<Map<String, dynamic>>? childrenMeasurementTaken,
    List<ChildGrowthMetaResponseModel>? allAntroData
  })
  async {

    List<Map<String, dynamic>> allChildren=[];

    for (int i = 0; i < childrenMeasurementTaken!.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        var gfReco = await checkRedFlagGrowthMonitoring(element['childenrollguid']
            ,element['measurement_taken_date'],element['cgmguid'],
            element,allAntroData!);

        if (Global.stringToDouble(
            element['weight_for_height'].toString()) ==
            1 ||
            gfReco=='GF2' ||
            Global.stringToInt(
                element['any_medical_major_illness'].toString()) ==
                1 ||
            Global.stringToDouble(element['weight_for_age'].toString()) ==
                1) {
          allChildren.add(element);
        }}
    }

    return allChildren;
  }

// children at Risk measument taken  all anthro
  Future<List<Map<String, dynamic>>> excuteChildrenAtRiskMeasurmentTakenAllAnthro({
    String? stateId, String? districtId,
    String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
    String? partnerId, String? crecheStatus, String? filterDate,
    List<Map<String, dynamic>>? childrenMeasurementTaken,
    List<ChildGrowthMetaResponseModel>? allAntroData
  })
  async {

    List<Map<String, dynamic>> allChildren=[];

    for (int i = 0; i < childrenMeasurementTaken!.length; i++) {
      var element=childrenMeasurementTaken[i];
      if(element['measurement_taken_date']!=null){
        if (Global.stringToDouble(
            element['weight_for_height_zscore'].toString()) <
            -3) {
          allChildren.add(element);
        }}
    }

    return allChildren;
  }

  Future<String?> checkSUWCondition(String enrolChildGuid,
      String measurement_date, Map<String, dynamic> growhthDetails)
  async {
    String? genratedValue;
    String lastMonthDate = Validate().getOneMonthPreviousDate(measurement_date);
    var lastMonthYear = Validate().dateToMonthYear(lastMonthDate);
    var lastAntroRecord = await ChildGrowthResponseHelper()
        .lastAntroDataByCmGuid(lastMonthYear, growhthDetails['cgmguid']);

    String secoundLast = Validate().getOneMonthPreviousDate(lastMonthDate);
    var secoundLastMonthYear = Validate().dateToMonthYear(secoundLast);
    var secondLastAntroRecord = await ChildGrowthResponseHelper()
        .lastAntroDataByCmGuid(secoundLastMonthYear, growhthDetails['cgmguid']);

    Map<String, dynamic> lastGrowhthDetails = {};
    if (lastAntroRecord.length > 0) {
      Map<String, dynamic> lastGrowthRec =
      jsonDecode(lastAntroRecord.first.responces!);
      var lastdChild = lastGrowthRec['anthropromatic_details'];
      if (lastdChild != null) {
        var child = lastdChild
            .where((element) => element['childenrollguid'] == enrolChildGuid
            &&(Global.stringToInt(element['do_you_have_height_weight'].toString()) == 1 ))
            .toList();
        if (child.length > 0) {
          lastGrowhthDetails = child.first;
        }
      }
    }

    Map<String, dynamic> secondlastGrowhthDetails = {};
    if (secondLastAntroRecord.length > 0) {
      Map<String, dynamic> secondlastGrowthRec =
      jsonDecode(secondLastAntroRecord.first.responces!);
      var lastdChild = secondlastGrowthRec['anthropromatic_details'];
      if (lastdChild != null) {
        var child = lastdChild
            .where((element) => element['childenrollguid'] == enrolChildGuid
            &&(Global.stringToInt(element['do_you_have_height_weight'].toString()) == 1 ))
            .toList();
        if (child.length > 0) {
          secondlastGrowhthDetails = child.first;
        }
      }
    }

    if (lastGrowhthDetails.isNotEmpty &&
        (Global.stringToDouble(growhthDetails['weight'].toString()) <=
            Global.stringToDouble(lastGrowhthDetails['weight'].toString()))) {
      genratedValue = 'GF1';

      if (secondlastGrowhthDetails.isNotEmpty &&
          (Global.stringToDouble(
              lastGrowhthDetails['weight'].toString())<=
              Global.stringToDouble(secondlastGrowhthDetails['weight'].toString()))) {
        genratedValue = 'GF2';
      }
    }
    return genratedValue;
  }

//With  local growth monitoring
  Future<String?> checkRedFlagGrowthMonitoring(String enrolChildGuid,
      String measurement_date, String cgmguid,Map<String, dynamic> growhthDetails,
      List<ChildGrowthMetaResponseModel> growthItems)
  async {
    String? genratedValue;

    // lastMonth
    String lastMonthDate = Validate().getOneMonthPreviousDate(measurement_date);
    var lastMonthYear = Validate().dateToMonthYear(lastMonthDate);

    ////secondLastMonth
    String secoundLast = Validate().getOneMonthPreviousDate(lastMonthDate);
    var secoundLastMonthYear = Validate().dateToMonthYear(secoundLast);


    var items=growthItems.where(
            (element) => (element.cgmguid == cgmguid))
        .toList();

    if(items.length>0){
      var filterdLastRecord=growthItems.where(
              (element) => (element.creche_id == items.first.creche_id
              && Validate().dateToMonthYear(element.measurement_date!)==
                      lastMonthYear))
          .toList();

      var filterdSencondLastRecord=growthItems.where(
              (element) => (element.creche_id == items.first.creche_id
              && Validate().dateToMonthYear(element.measurement_date!)==
                      secoundLastMonthYear))
          .toList();

      Map<String, dynamic> lastGrowhthDetails = {};
      Map<String, dynamic> secondlastGrowhthDetails = {};

      if(filterdLastRecord.length>0){
        var lastAntroRecord=filterdLastRecord.first;

        if (lastAntroRecord.responces!=null) {
          Map<String, dynamic> lastGrowthRec =
          jsonDecode(lastAntroRecord.responces!);
          var lastdChild = lastGrowthRec['anthropromatic_details'];
          if (lastdChild != null) {
            var child = lastdChild
                .where((element) => element['childenrollguid'] == enrolChildGuid
                &&(Global.stringToInt(element['do_you_have_height_weight'].toString()) == 1 ))
                .toList();
            if (child.length > 0) {
              lastGrowhthDetails = child.first;
            }
          }
        }
      }

      if(filterdSencondLastRecord.length>0){
        var secondLastAntroRecord=filterdSencondLastRecord.first;
        if (secondLastAntroRecord.responces!=null) {
          Map<String, dynamic> lastGrowthRec =
          jsonDecode(secondLastAntroRecord.responces!);
          var lastdChild = lastGrowthRec['anthropromatic_details'];
          if (lastdChild != null) {
            var child = lastdChild
                .where((element) => element['childenrollguid'] == enrolChildGuid
                &&(Global.stringToInt(element['do_you_have_height_weight'].toString()) == 1 ))
                .toList();
            if (child.length > 0) {
              secondlastGrowhthDetails = child.first;
            }
          }
        }
      }



      if (lastGrowhthDetails.isNotEmpty &&
          (Global.stringToDouble(growhthDetails['weight'].toString()) <=
              Global.stringToDouble(lastGrowhthDetails['weight'].toString()))) {
        genratedValue = 'GF1';

        if (secondlastGrowhthDetails.isNotEmpty &&
            (Global.stringToDouble(
                lastGrowhthDetails['weight'].toString())<=
                Global.stringToDouble(secondlastGrowhthDetails['weight']
                    .toString()))) {
          genratedValue = 'GF2';
        }
      }

    }



    return genratedValue;
  }

  String crecheDataQuery(){
    return '''SELECT *
FROM (
    SELECT 
        name,
        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase,responces as crecheData

    FROM ${eligbleCrecheQuery()}  
) ''';
  }

  String crecheDataForJoinQuery(){
    return '''FROM (
    SELECT 
        name,

        CASE WHEN INSTR(responces, 'partner_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'partner_id":"') + LENGTH('partner_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS partner_id,

        CASE WHEN INSTR(responces, 'state_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'state_id":"') + LENGTH('state_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'state_id":"') + LENGTH('state_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS state_id,

        CASE WHEN INSTR(responces, 'district_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'district_id":"') + LENGTH('district_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'district_id":"') + LENGTH('district_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS district_id,

        CASE WHEN INSTR(responces, 'block_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'block_id":"') + LENGTH('block_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'block_id":"') + LENGTH('block_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS block_id,

        CASE WHEN INSTR(responces, 'gp_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'gp_id":"') + LENGTH('gp_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS gp_id,

        CASE WHEN INSTR(responces, 'village_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'village_id":"') + LENGTH('village_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'village_id":"') + LENGTH('village_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS village_id,

        CASE WHEN INSTR(responces, 'creche_status_id":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_status_id":"') + LENGTH('creche_status_id":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_status_id,

        CASE WHEN INSTR(responces, 'creche_opening_date":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'creche_opening_date":"') + LENGTH('creche_opening_date":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS creche_opening_date,

        CASE WHEN INSTR(responces, 'phase":"') > 0 
        THEN SUBSTR(
            responces,
            INSTR(responces, 'phase":"') + LENGTH('phase":"'),
            INSTR(
                SUBSTR(
                    responces,
                    INSTR(responces, 'phase":"') + LENGTH('phase":"')
                ),
                '","'
            ) - 1
        ) ELSE NULL END AS phase ,responces as crecheData

    FROM ${eligbleCrecheQuery()} 
) ''';
  }

  String crecheWhereCondition( String? stateId, String? districtId,
      String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
      String? partnerId, String? crecheStatus, String? filterDate,int? quryType)
  {
    String whereCluse='';
    if(Global.validString(stateId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and state_id='$stateId'";
      }else whereCluse="where state_id='$stateId'";
    }
    if(Global.validString(districtId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and district_id='$districtId'";
      }else whereCluse="where district_id='$districtId'";
    }
    if(Global.validString(blockId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and block_id='$blockId'";
      }else whereCluse="where block_id='$blockId'";
    }
    if(Global.validString(gpId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and gp_id='$gpId'";
      }else whereCluse="where gp_id='$gpId'";
    }
    if(Global.validString(villageId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and village_id='$villageId'";
      }else whereCluse="where village_id='$villageId'";
    }

    if(Global.validString(crecheStatus)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche_status_id='$crecheStatus'";
      }else whereCluse="where creche_status_id='$crecheStatus'";
    }

    if(Global.validString(crecheId)){
      if(quryType==1){
        if(Global.validString(whereCluse)){
          whereCluse="$whereCluse and name=$crecheId";
        }else whereCluse="where name=$crecheId";
      }else{
        if(Global.validString(whereCluse)){
          whereCluse="$whereCluse and creche_id=$crecheId";
        }else whereCluse="where creche_id=$crecheId";
      }

    }

    if(Global.validString(partnerId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and partner_id='$partnerId'";
      }else whereCluse="where partner_id='$partnerId'";
    }

    if(Global.validString(phase)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and phase='$phase'";
      }else whereCluse="where phase='$phase'";
    }
    if(Global.validString(filterDate)&&crecheStatus!='1'){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche_opening_date <='$filterDate'";
      }else whereCluse="where creche_opening_date <= '$filterDate'";
    }
    return whereCluse;
  }




  String eligbleCrecheQuery()
  {
    return '(select * from tab_creche_response where name in (select DISTINCT(creche_id) from house_hold_responce))';
  }

  String crecheWhereWithJoinCondition( String? stateId, String? districtId,
      String? blockId, String? gpId,String? villageId,String? crecheId, String? phase,
      String? partnerId, String? crecheStatus, String? filterDate)
  {
    String whereCluse='';
    if(Global.validString(stateId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.state_id='$stateId'";
      }else whereCluse="where creche.state_id='$stateId'";
    }
    if(Global.validString(districtId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.district_id='$districtId'";
      }else whereCluse="where creche.district_id='$districtId'";
    }
    if(Global.validString(blockId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.block_id='$blockId'";
      }else whereCluse="where creche.block_id='$blockId'";
    }
    if(Global.validString(gpId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.gp_id='$gpId'";
      }else whereCluse="where creche.gp_id='$gpId'";
    }
    if(Global.validString(villageId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.village_id='$villageId'";
      }else whereCluse="where creche.village_id='$villageId'";
    }

    if(Global.validString(crecheStatus)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.creche_status_id='$crecheStatus'";
      }else whereCluse="where creche.creche_status_id='$crecheStatus'";
    }

    if(Global.validString(crecheId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.name='$crecheId'";
      }else whereCluse="where creche.name='$crecheId'";
    }

    if(Global.validString(partnerId)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.partner_id='$partnerId'";
      }else whereCluse="where creche.partner_id='$partnerId'";
    }

    if(Global.validString(phase)){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.phase='$phase'";
      }else whereCluse="where creche.phase='$phase'";
    }
    if(Global.validString(filterDate)&&crecheStatus!='1'){
      if(Global.validString(whereCluse)){
        whereCluse="$whereCluse and creche.creche_opening_date <='$filterDate'";
      }else whereCluse="where creche.creche_opening_date <= '$filterDate'";
    }
    return whereCluse;
  }






}