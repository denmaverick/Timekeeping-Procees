



Declare
                                         @datesStart date = '2019-01-01'
										,@datesEnd date = GETDATE() - 1
                                        ,@device_employee_ids varchar(50) = '0003847880' 
										,@overtimerestminutes int = 30
										,@whenToRestAfterMinutesForRestDayHoliday  int= 240
										,@overtimerestminutesForRestDayHoliday int = 60
										,@latelimit int = 60
										,@DatabaseName varchar(50) 
										,@Campus varchar(10) = 'ORT'
										,@SQL NVARCHAR(MAX)


--0006141445
--'0006160038'

--special
--0006287084
--0003847880


Declare @GRANDFinaleTimekeepingTable  TABLE(  
									    attendance_date			date INDEX Indexattendance_date CLUSTERED
									  , ScheduleDayName		    Varchar(50)
									  , SchedDayType			Varchar(50)								 
									  ,	TimeIns					time 
									  ,	TimeOuts				time 
									  , ShiftIns			    time 							
									  ,	ShiftOuts			    time 
									  ,	WorkHours			    int
									  , RequiredHours			int
									  , PartTimeHours			int
									  ,	Tardiness				int
									  ,	Undertime				int
									  , LeaveWithPay			int
									  , LeaveWithOutPay			int
									  ,	Overtime				int
									  ,	Unauthorized			int
									  , FileAdjustmentStatus	Varchar(50)
									  , FileAdjustmentType		Varchar(50)
									  , FileleaveWithPay		Varchar(50)
									  , FileadjustmentScheduleTimeStart		time
									  , FileadjustmentScheduleTimeEnd		time
									  , DurationDays              decimal(3,2)							
									  ,	Duration	              Varchar(50)
								  )


Declare @FinalsTimekeepingTable  TABLE(  
									    attendance_date			date INDEX Indexattendance_date CLUSTERED
									  , ScheduleDayName		    Varchar(50)
									  , SchedDayType			Varchar(50)								 
									  ,	TimeIns					time 
									  ,	TimeOuts				time 
									  , ShiftIns			    time 							
									  ,	ShiftOuts			    time 
									  ,	WorkHours			    int
									  , RequiredHours			int
									  , PartTimeHours			int
									  ,	Tardiness				int
									  ,	Undertime				int
									  , LeaveWithPay			int
									  , LeaveWithOutPay			int
									  ,	Overtime				int
									  ,	Unauthorized			int
								  )

Declare @SemiFinalsTimekeepingTable  TABLE(  Attendance_ID			int INDEX IndexAttendance_ID CLUSTERED
									  , attendance_date			date
									  , ShiftOrder				varchar(50)  
									  , SchedType				Varchar(50) 
									  , SchedDayType			Varchar(50)
									  ,	SpecialdateStart		date
									  ,	SpecialdateEnd		    date
									  , ScheduleDayName		    Varchar(50)
									  , ScheduleTimeins			time 							
									  ,	Scheduletimeouts		time 
									  ,	Timeins					time 
									  ,	timeouts				time 
									  ,	Tardiness				int
									  ,	Undertime				int
									  ,	Overtime				int
									  ,	FirstTimeIn				time
									  ,	LastTimeOut				time
									  ,	FirstScheduleTimeIns	time
									  ,	LastScheduleTimeOuts    time
									  ,	ShiftDuration		    int
									  ,	ShiftDurationOFDay		int
									  ,	ShiftOrderNumberOFDay	int
								  )

Declare @PrelimTimekeepingTable  TABLE  (	   	Attendance_ID int INDEX IndexAttendance_ID CLUSTERED
									  , attendance_date   date
									  , ShiftOrder varchar(50)  INDEX IndexShiftOrder NONCLUSTERED
									  , SchedType  Varchar(50) INDEX IndexSchedType NONCLUSTERED
									  , SchedDayType    Varchar(50)
									  ,	SpecialdateStart  date
									  ,	SpecialdateEnd   date
									  , ScheduleDayName Varchar(50)
									  , ScheduleTimeins	time 							
									  ,	Scheduletimeouts time 
									  ,	Timeins			time 
									  ,	transact		varchar(50)  
									  ,	timeouts		time 
									  ,	transact2		varchar(50)
									  ,	WorkMinutes		int
									  ,	TimeInDiff		int 
									  ,	TimeInRemark	varchar(50)
									  ,	TimeOutDiff		int
									  ,	TimeoutRemark	varchar(50)
									  ,	FirstTimeIn		time
									  ,	LastTimeOut		time
									  ,	ShiftDuration	int
									  ,   LastShiftBreakminutes int
									  ,   lastShiftOutDiffminutes int
									  ,   lastShiftDuration int
								      , INDEX IndexForTimeouts NONCLUSTERED(attendance_date,ShiftOrder ,TimeOutDiff)
									  , INDEX IndexForTimeins NONCLUSTERED(attendance_date,ShiftOrder,TimeInDiff)
								  )


							  
Declare @TimeTable  TABLE  (	     attendance_date   date INDEX IndexSchedType CLUSTERED
									  , Timeins			time 
									  ,	transact		varchar(50)  
									  ,	timeouts		time 
									  ,	transact2		varchar(50)
								  )

Declare @ScheduleTimeTable TABLE  (	  attendance_date   date INDEX Indexattendance_date CLUSTERED
								      , Timeins			time 
									  ,	transact		varchar(50)  
									  ,	timeouts		time 
									  ,	transact2		varchar(50)
									  , SchedType      Varchar(50) INDEX IndexSchedType NONCLUSTERED
									  , SchedDayType    Varchar(50)
									  ,	SpecialdateStart  date
									  ,	SpecialdateEnd   date
									  , ScheduleDayName Varchar(50)	   
									  , ScheduleTimeins	time 							
									  ,	Scheduletimeouts time 
									  ,	LastTimeIn		time
									  ,	LastTimeOut		time
									  ,	ShiftOrder	Varchar(50) INDEX IndexShiftOrder NONCLUSTERED
									  ,	TableOrder	int

								  )

								  
Declare @HalfDayTable TABLE			 (  HalfDayDate				  date  INDEX IndexHalfDayDate CLUSTERED
									  , WithLeave                int
								      , LeaveWithTardiness       int
									  ,	LeaveWithUnderTime       int
									  ,	LeaveWithUnauthorized    int			  						
								     )

Declare @ScheduleTable  TABLE  (	   
									   SchedType  Varchar(50) INDEX IndexSchedType CLUSTERED
									  ,SchedDayType Varchar(50)
									  ,	SpecialdateStart  date
									  ,	SpecialdateEnd   date
									  , ScheduleDayName Varchar(50)
									  , ScheduleTimeins	time 							
									  ,	Scheduletimeouts time 
									  ,	LastTimeIn		time
									  ,	LastTimeOut		time
									  ,	ShiftOrder	Varchar(50)
									  ,	TableOrder	int
									  , INDEX IndexForDates NONCLUSTERED(SpecialdateStart,SpecialdateEnd)
								  )

Declare @FileAdjustmentsTable TABLE  (  FileAdjustmentType        Varchar(50)	  
									  , DateFiled                 date           --?? if usefull
								      , DateProcessed             date           --?? if usefull
									  ,	ScheduledateStart         date
									  ,	ScheduledateEnd           date									  
									  , ScheduleTimeStart	      time 							
									  ,	ScheduleTimeEnd           time 
									  , DurationDays              decimal(3,1)							
									  ,	Duration	              Varchar(50) 
									  , FileLeaveType             Varchar(100)
									  , FileLeaveWithPay          Varchar(50)	 
									  ,	FileAdjustmentStatus      Varchar(50)  INDEX IndexFileAdjustmentStatus NONCLUSTERED
									  , INDEX IndexForDates NONCLUSTERED(ScheduledateStart,ScheduledateEnd)
									  , INDEX IndexForTimes NONCLUSTERED(ScheduleTimeStart,ScheduleTimeEnd)
								     )




insert into @FileAdjustmentsTable
	
values
	    ('Leave' ,'2019-12-31','2019-12-31' ,'2020-08-14', '2020-08-14' ,'08:30:00','17:30:00','1.0','Full Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-22', '2020-09-22' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-21', '2020-09-21' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-25', '2020-09-25' ,'08:30:00','13:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-28', '2020-09-28' ,'08:30:00','13:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-18', '2020-09-18' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-17', '2020-09-17' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-16', '2020-09-16' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-15', '2020-09-15' ,'08:30:00','13:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-14', '2020-09-14' ,'08:30:00','13:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-11', '2020-09-11' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-10', '2020-09-10' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-08', '2020-09-08' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-09', '2020-09-09' ,'13:30:00','17:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   ,('Leave' ,'2019-12-31','2019-12-31' ,'2020-09-03', '2020-09-03' ,'08:30:00','13:30:00','0.5','Half Day' ,'20-21 Vacation Leave with Pay' ,'1' ,'Approved')
	   --,('Overtime' ,'2019-12-31','2019-12-31' ,'2020-09-17', '2020-09-17' ,'18:00:00','19:00:00','0.0','' ,'' ,'' ,'Approved')
	   --,('Undertime' ,'2019-12-31','2019-12-31' ,'2020-09-18', '2020-09-18' ,'16:30:00','17:30:00','0.0','' ,'' ,'' ,'Approved')


insert into @ScheduleTable

values
	 -- ('Regular' ,'Work' ,'' ,'', 'Monday' ,'08:30:00','11:30:00','','','First' , '1')
	 --,('Regular' ,'Work','' ,'', 'Monday' ,'12:30:00','17:30:00','08:30:00','11:30:00','Last','2')
	 --,('Regular' ,'Work','' ,'', 'Tuesday' ,'08:30:00','11:30:00','','','First' , '1')
	 --,('Regular' ,'Work','' ,'', 'Tuesday' ,'12:30:00','17:30:00','08:30:00','11:30:00','Last','2')
	 --,('Regular' ,'Work','' ,'', 'Wednesday' ,'08:30:00','11:30:00','','','First' , '1')
	 --,('Regular' ,'Work','' ,'', 'Wednesday' ,'12:30:00','17:30:00','08:30:00','11:30:00','Last','2')
	 --,('Regular' ,'Work','' ,'', 'Thursday' ,'08:30:00','11:30:00','','','First' , '1')
	 --,('Regular' ,'Work','' ,'', 'Thursday' ,'12:30:00','17:30:00','08:30:00','11:30:00','Last','2')
	 --,('Regular' ,'Work','' ,'', 'Friday' ,'08:30:00','11:30:00','','','First' , '1')
	 --,('Regular' ,'Work','' ,'', 'Friday' ,'12:30:00','17:30:00','08:30:00','11:30:00','Last','2')
	 --,('Regular' ,'Rest','' ,'', 'Saturday' ,'00:00:00','23:59:59','','','Last','1')
	 --,('Regular' ,'Rest','' ,'', 'Sunday' ,'00:00:00','23:59:59','','','Last','1')

	 --,('Special','Special','2020-02-21' ,'2020-02-26', 'Monday' ,'08:30:00','17:30:00','','','Last' , '1')
	 --,('Special','Special','2020-02-21' ,'2020-02-26', 'Wednesday' ,'08:30:00','17:30:00','','','Last' , '1')
	 --,('Special','Special','2020-02-27' ,'2020-02-27', 'Thursday' ,'11:30:00','17:30:00','','','Last' , '1')
	 --,('Special','Holiday','2020-09-23' ,'2020-09-23', 'Wednesday' ,'00:00:00','23:59:59','','','Last' , '1')

	  --,('Regular' ,'Rest','' ,'', 'Friday' ,'00:00:00','23:59:59','','','Last','1')

      ('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Monday' ,'07:00:00','10:00:00','','','First' , '1')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Monday' ,'11:00:00','12:00:00','07:00:00','10:00:00','2','2')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Monday' ,'13:30:00','16:30:00','11:00:00','12:00:00','3','3')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Monday' ,'17:00:00','18:00:00','13:30:00','16:30:00','Last','4')

	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Tuesday' ,'07:00:00','10:00:00','','','First' , '1')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Tuesday' ,'10:00:00','11:30:00','07:00:00','10:00:00','2','2')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Tuesday' ,'12:30:00','13:30:00','10:00:00','11:30:00','3','3')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Tuesday' ,'14:00:00','16:00:00','12:30:00','13:30:00','4','4')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Tuesday' ,'17:00:00','19:30:00','14:00:00','16:00:00','Last','5')


	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Wednesday' ,'07:00:00','10:00:00','','','First' , '1')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Wednesday' ,'10:30:00','13:30:00','07:00:00','10:00:00','2','2')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Wednesday' ,'13:30:00','15:00:00','10:30:00','13:30:00','3','3')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Wednesday' ,'17:00:00','18:30:00','13:30:00','15:00:00','Last','4')

	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Thursday' ,'07:00:00','11:30:00','','','First' , '1')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Thursday' ,'13:00:00','15:00:00','07:00:00','11:30:00','2','2')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Thursday' ,'15:30:00','20:00:00','13:00:00','15:00:00','Last','3')

	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Friday' ,'07:00:00','08:00:00','','','First' , '1')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Friday' ,'08:30:00','10:30:00','07:00:00','08:00:00','2','2')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Friday' ,'13:30:00','16:30:00','08:30:00','10:30:00','Last','3')

	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Saturday' ,'07:00:00','10:00:00','','','First' , '1')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Saturday' ,'11:30:00','12:30:00','07:00:00','10:00:00','2','2')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Saturday' ,'13:30:00','15:00:00','11:30:00','12:30:00','3','3')
	 ,('Special' ,'Work','2019-12-31' ,'2021-01-31', 'Saturday' ,'17:30:00','18:30:00','13:30:00','15:00:00','Last','4')
	 
	 ,('Special' ,'Rest','2019-12-31' ,'2021-01-31', 'Sunday' ,'00:00:00','23:59:59','','','Last','1');

SET	@DatabaseName ='EmployeeTimekeep_'+@Campus


SET @SQL = N'
Select 
attendance_date 
,attendance_time as Timeins 
 , transact
 ,  (Select min(attendance_time) 
      from  '+Quotename(@DatabaseName)+'
      where attendance_time > main.attendance_time 
            and transact = ''Valid Exit Access'' 
       and attendance_date = main.attendance_date
      and device_employee_id = @device_employee_ids  ) as timeouts

 ,'' Valid Exit Access'' as transact2

 From '+Quotename(@DatabaseName)+'  main

 where transact =  ''Valid Entry Access''

 and device_employee_id = @device_employee_ids
 
 and attendance_date between @datesStart and @datesEnd'

 insert into @TimeTable
 exec sp_executesql @SQL
 , N'@device_employee_ids varchar(50), @datesStart date , @datesEnd date'
 ,@device_employee_ids, @datesStart, @datesEnd ;

--insert into @TimeTable
--Select 
--attendance_date 
--,attendance_time as Timeins 
-- , transact
-- ,  (Select min(attendance_time) 
--      from [EmployeeTimekeep_ORT]
--      where attendance_time > main.attendance_time 
--            and transact = 'Valid Exit Access' 
--       and attendance_date = main.attendance_date
--      and device_employee_id = @device_employee_ids) as timeouts

-- , 'Valid Exit Access' as transact2

-- From [EmployeeTimekeep_ORT]  main

-- where transact = 'Valid Entry Access'

-- and device_employee_id = @device_employee_ids
 
-- and attendance_date between @datesStart and @datesEnd;

--Welcome to the Liar game
--Elimination Method


insert into  @ScheduleTimeTable

 Select * from  @TimeTable timeT
 
 LEFT JOIN @ScheduleTable Sched on Sched.ScheduleDayName =  DATENAME(dw, timeT.attendance_date)

 where (SchedType ='Regular' 
		and attendance_date not in (Select attendance_date 
									from @TimeTable timeT
									LEFT JOIN @ScheduleTable Sched 
									on Sched.ScheduleDayName =  DATENAME(dw, timeT.attendance_date)
									where SchedType = 'Special' and attendance_date between SpecialdateStart and SpecialdateEnd) 
	    ) 
  
 OR (SchedType = 'Special' and attendance_date between SpecialdateStart and SpecialdateEnd);

insert into @PrelimTimekeepingTable

Select  ROW_NUMBER() OVER (
	ORDER BY  attendance_date , TableOrder , Timeins
   ) Attendace_ID,
   
   attendance_date , ShiftOrder, SchedType ,SchedDayType ,SpecialdateStart  
  ,SpecialdateEnd , ScheduleDayName , ScheduleTimeins , Scheduletimeouts ,

(Case when ShiftOrder ='First' OR (Select Count(sched.ScheduleDayName) 
								   from @ScheduleTable sched 
								   where sched.SchedType = main.SchedType
								      and main.ScheduleDayName = sched.ScheduleDayName
									  ) = 1 then (Select min(Timeins) from @ScheduleTimeTable where attendance_date = main.attendance_date)	
	  else Timeins end ) as Timeins  
 , transact 

, (Case when ShiftOrder ='Last' OR (Select Count(sched.ScheduleDayName) 
								   from @ScheduleTable sched 
								   where sched.SchedType = main.SchedType
								      and main.ScheduleDayName = sched.ScheduleDayName
									  ) = 1 then (Select max(timeouts) from @ScheduleTimeTable where attendance_date = main.attendance_date)
	    else timeouts end ) as timeouts 

 , transact2 

 ,(Case  
 when SchedDayType in ('Rest' ,'Holiday') 
   OR (Select Count(sched.ScheduleDayName) 
	   from @ScheduleTable sched 
	   where sched.SchedType = main.SchedType
	   and main.ScheduleDayName = sched.ScheduleDayName) = 1 
  then  DATEDIFF(MINUTE ,    (Select min(Timeins) from @ScheduleTimeTable where attendance_date = main.attendance_date)  , (Select max(timeouts) from @ScheduleTimeTable where attendance_date = main.attendance_date))
 when ShiftOrder ='First' then  DATEDIFF(MINUTE ,    (Select min(Timeins) from @ScheduleTimeTable where attendance_date = main.attendance_date)  , timeouts)
 when ShiftOrder ='Last'  then  DATEDIFF(MINUTE , Timeins  , (Select max(timeouts) from @ScheduleTimeTable where attendance_date = main.attendance_date))

 else DATEDIFF(MINUTE , Timeins , timeouts)

end ) as WorkMinutes

,  (Case  when SchedDayType in ('Rest' ,'Holiday')  then 0 
		when ShiftOrder ='First' OR (Select Count(sched.ScheduleDayName) 
	   from @ScheduleTable sched 
	   where sched.SchedType = main.SchedType
	   and main.ScheduleDayName = sched.ScheduleDayName) = 1 
       then  ABS(DATEDIFF(MINUTE ,  (Select min(Timeins) from @ScheduleTimeTable where attendance_date = main.attendance_date) , ScheduleTimeins))
       else ABS(DATEDIFF(MINUTE ,  Timeins  , ScheduleTimeins))
 end ) as TimeInDiff

,  (case when SchedDayType in ('Rest' ,'Holiday')  then 'On-Time'
		 when ShiftOrder ='First' OR (Select Count(sched.ScheduleDayName) 
	   from @ScheduleTable sched 
	   where sched.SchedType = main.SchedType
	   and main.ScheduleDayName = sched.ScheduleDayName) = 1 
		then (case when (DATEDIFF(MINUTE , (Select min(Timeins) from @ScheduleTimeTable where attendance_date = main.attendance_date), ScheduleTimeins) < 0)  then 'Late' 
                   when (DATEDIFF(MINUTE , (Select min(Timeins) from @ScheduleTimeTable where attendance_date = main.attendance_date), ScheduleTimeins) = 0)  then 'On-Time' 
                  else 'Early' end) 

       else (case when (DATEDIFF(MINUTE ,  Timeins  , ScheduleTimeins) < 0)  then 'Late' 
                  when (DATEDIFF(MINUTE ,  Timeins  , ScheduleTimeins) = 0)  then 'On-Time' 
		          else 'Early' end)
       end) as TimeInRemark 

,  (Case when SchedDayType in ('Rest' ,'Holiday')  then 0
		when ShiftOrder ='Last' OR (Select Count(sched.ScheduleDayName) 
								    from @ScheduleTable sched 
								    where sched.SchedType = main.SchedType
								    and main.ScheduleDayName = sched.ScheduleDayName) = 1 
       then  ABS(DATEDIFF(MINUTE , (Select max(timeouts) from @ScheduleTimeTable where attendance_date = main.attendance_date) , Scheduletimeouts))

       else  ABS(DATEDIFF(MINUTE , timeouts  , Scheduletimeouts))

end ) as TimeOutDiff

,  (case when SchedDayType in ('Rest' ,'Holiday') then 'Over-Time'
		 when ShiftOrder ='Last'  OR (Select Count(sched.ScheduleDayName) 
								     from @ScheduleTable sched 
								     where sched.SchedType = main.SchedType
								     and main.ScheduleDayName = sched.ScheduleDayName) = 1 
         then  (case when (DATEDIFF(MINUTE ,  (Select max(timeouts) from @ScheduleTimeTable where attendance_date = main.attendance_date) , Scheduletimeouts) > 0)  then 'Under-Time' 
                    when (DATEDIFF(MINUTE ,  (Select max(timeouts) from @ScheduleTimeTable where attendance_date = main.attendance_date) , Scheduletimeouts) = 0)  then 'On-Time' 
                    else 'Over-Time' end)

         else (case when (DATEDIFF(MINUTE ,   timeouts  , Scheduletimeouts) > 0)  then 'Under-Time' 
                   when (DATEDIFF(MINUTE ,   timeouts  , Scheduletimeouts) = 0)  then 'On-Time' 
		           else 'Over-Time' end)
         end) as TimeoutRemark 
 
, (Select min(Timeins) from @ScheduleTimeTable where attendance_date = main.attendance_date) as FirstTimeIn
, (Select max(timeouts) from @ScheduleTimeTable where attendance_date = main.attendance_date) as LastTimeOut

, DATEDIFF(MINUTE ,  ScheduleTimeins , Scheduletimeouts) as ShiftDuration

, ( case when ShiftOrder = 'First' then 0 
        else ABS(DATEDIFF(MINUTE,LastTimeOut ,ScheduleTimeins )) end ) as lastShiftBreakminutes

, ( case when ShiftOrder = 'First' then 0 
        else ABS(DATEDIFF(MINUTE,  timeouts , LastTimeOut )) end ) as lastShiftOutDiffminutes

, ( case when ShiftOrder = 'First' then 0 else DATEDIFF(MINUTE ,  LastTimeIn , LastTimeOut) end ) as LastShiftDuration


from @ScheduleTimeTable main

--where timeouts is not null


order by attendance_date  ,TableOrder , Timeins;

insert into @SemiFinalsTimekeepingTable
Select NewAttendace_ID , attendance_date , ShiftOrder , SchedType , SchedDayType , SpecialdateStart , SpecialdateEnd , ScheduleDayName , ScheduleTimeins , Scheduletimeouts , Timeins ,timeouts

--, transact , transact2, WorkMinutes 

--,TimeInDiff,TimeInRemark , TimeOutDiff , TimeoutRemark 

 , (Case when TimeInRemark = 'Late' then TimeInDiff  else  0 end  ) as Tardiness

 , (Case when TimeoutRemark = 'Under-Time' then TimeOutDiff  else  0 end  ) as Undertime 
 
  , (Case  when SchedDayType in ('Rest' ,'Holiday')  then WorkMinutes
		   when TimeoutRemark = 'Over-Time' and ShiftOrder = 'Last' then TimeOutDiff 		 
   else  0 end  ) as Overtime 
 
 , FirstTimeIn,LastTimeOut  , FirstScheduleTimeins, LastScheduletimeouts
 
  , (Case  when SchedDayType in ('Rest' ,'Holiday')  then WorkMinutes			 
   else  ShiftDuration end  ) ShiftDuration 
 
 , (Case  when SchedDayType in ('Rest' ,'Holiday')  then WorkMinutes			 
   else  ShiftDurationOFday end  )ShiftDurationOFday 
 
 
 ,ShiftOrderNumberOFday 



from(
Select
ROW_NUMBER() OVER (
	ORDER BY  attendance_date Desc , min(ScheduleTimeins) 
   ) NewAttendace_ID,

 attendance_date ,ShiftOrder, min(SchedType) as  SchedType ,min(SchedDayType) as SchedDayType, min(SpecialdateStart) as SpecialdateStart
  ,min(SpecialdateEnd) as SpecialdateEnd , min(ScheduleDayName) as ScheduleDayName  , min(ScheduleTimeins) as ScheduleTimeins , min (Scheduletimeouts) as Scheduletimeouts

,(Case when ShiftOrder ='First'
	   then (Select Timeins 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = (Select min(Attendance_ID) 
									 from @PrelimTimekeepingTable 
									 where TimeOutDiff = Min(mainFirst.TimeOutDiff)
								     and attendance_date= mainFirst.attendance_date 
									 and ShiftOrder = mainFirst.ShiftOrder ) ) 

	when ShiftOrder ='Last' 
	then (Select Timeins 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = (Select min(Attendance_ID) 
						  from @PrelimTimekeepingTable 
						  where TimeInDiff = Min(mainFirst.TimeInDiff)
						  and attendance_date= mainFirst.attendance_date
						  and ShiftOrder = mainFirst.ShiftOrder   ) ) 
	
	else (Select Timeins 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = min(mainFirst.Attendance_ID) 
		  and ShiftOrder = mainFirst.ShiftOrder 
		  ) 	  						  
						 end) as Timeins

,  min(transact) as transact

,(Case when ShiftOrder ='First'
	   then (Select timeouts 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = (Select min(Attendance_ID) 
									 from @PrelimTimekeepingTable 
									 where TimeOutDiff = Min(mainFirst.TimeOutDiff)
								     and attendance_date= mainFirst.attendance_date  
									 and ShiftOrder = mainFirst.ShiftOrder ) ) 

	when ShiftOrder ='Last' 
	then (Select timeouts 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = (Select min(Attendance_ID) 
						  from @PrelimTimekeepingTable 
						  where TimeInDiff = Min(mainFirst.TimeInDiff)
						  and attendance_date= mainFirst.attendance_date 
						  and ShiftOrder = mainFirst.ShiftOrder  ) ) 			  
	else (Select timeouts 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = max(mainFirst.Attendance_ID) 
		  and ShiftOrder = mainFirst.ShiftOrder 
		  ) 							  
						 end) as timeouts

, min (transact2) as transact2 
 
, (Case when ShiftOrder ='First'
	   then (Select WorkMinutes 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = (Select min(Attendance_ID) 
									 from @PrelimTimekeepingTable 
									 where TimeOutDiff = Min(mainFirst.TimeOutDiff)
								     and attendance_date= mainFirst.attendance_date 
									 and ShiftOrder = mainFirst.ShiftOrder  ) ) 

	when ShiftOrder ='Last' 
	then (Select WorkMinutes 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = (Select min(Attendance_ID) 
						  from @PrelimTimekeepingTable 
						  where TimeInDiff = Min(mainFirst.TimeInDiff)
						  and attendance_date= mainFirst.attendance_date 
						  and ShiftOrder = mainFirst.ShiftOrder  ) ) 	
						  		  
		else SUM(mainFirst.WorkMinutes)			  
						 end) as WorkMinutes



,  (Case when ShiftOrder not in ('First','Last') 
	   then (Select TimeInDiff 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = min(mainFirst.Attendance_ID) 
			 and ShiftOrder = mainFirst.ShiftOrder 
			) 

else min(TimeInDiff)
end) as TimeInDiff 



,  (Case when ShiftOrder ='First'
	   then (Select TimeInRemark 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = (Select min(Attendance_ID) 
									 from @PrelimTimekeepingTable 
									 where TimeOutDiff = Min(mainFirst.TimeOutDiff)
								     and attendance_date= mainFirst.attendance_date  
									 and ShiftOrder = mainFirst.ShiftOrder ) ) 

	when ShiftOrder ='Last' 
	then (Select TimeInRemark 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = (Select min(Attendance_ID) 
						  from @PrelimTimekeepingTable 
						  where TimeInDiff = Min(mainFirst.TimeInDiff)
						  and attendance_date= mainFirst.attendance_date 
						  and ShiftOrder = mainFirst.ShiftOrder  ) ) 			  

	else (Select TimeInRemark 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = min(mainFirst.Attendance_ID) 
		  and ShiftOrder = mainFirst.ShiftOrder 
		  ) 						  
						 end) as TimeInRemark


, (Case when ShiftOrder not in ('First','Last') 
	   then (Select TimeOutDiff 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = max(mainFirst.Attendance_ID) 
			 and ShiftOrder = mainFirst.ShiftOrder 
			) 
else min(TimeOutDiff)
end) as TimeOutDiff 

, (Case when ShiftOrder ='First'
	   then (Select TimeoutRemark 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = (Select min(Attendance_ID) 
									 from @PrelimTimekeepingTable 
									 where TimeOutDiff = Min(mainFirst.TimeOutDiff)
								     and attendance_date= mainFirst.attendance_date  
									 and ShiftOrder = mainFirst.ShiftOrder ) ) 

	when ShiftOrder ='Last' 
	then (Select TimeoutRemark 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = (Select min(Attendance_ID) 
						  from @PrelimTimekeepingTable 
						  where TimeInDiff = Min(mainFirst.TimeInDiff)
						  and attendance_date= mainFirst.attendance_date  
						  and ShiftOrder = mainFirst.ShiftOrder ) ) 			  

	else (Select TimeoutRemark 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = max(mainFirst.Attendance_ID) 
		  and ShiftOrder = mainFirst.ShiftOrder 
		  ) 
		  						  
						 end) as TimeoutRemark

, min(FirstTimeIn) as FirstTimeIn , min(LastTimeOut) as LastTimeOut , min(ShiftDuration) as ShiftDuration 



,(Select min(ScheduleTimeins) 
			from @PrelimTimekeepingTable 
			where attendance_date = mainFirst.attendance_date) as FirstScheduleTimeins

,(Select Max(Scheduletimeouts)
			from @PrelimTimekeepingTable 
			where attendance_date = mainFirst.attendance_date) as LastScheduletimeouts

, ( Select sum(ShiftDuration) as ShiftDuration
	 from (Select ShiftOrder , min(ShiftDuration) as ShiftDuration 
			from @PrelimTimekeepingTable 
			where attendance_date = mainFirst.attendance_date 
			group by attendance_date , ShiftOrder) as GetSum 
	) as ShiftDurationOFday 

, ( Select Count(Distinct ShiftOrder)
			from @PrelimTimekeepingTable 
			where attendance_date = mainFirst.attendance_date 
	) as ShiftOrderNumberOFday 

, (Case when ShiftOrder ='First'
	   then (Select LastShiftBreakminutes 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = (Select min(Attendance_ID) 
									 from @PrelimTimekeepingTable 
									 where TimeOutDiff = Min(mainFirst.TimeOutDiff)
								     and attendance_date= mainFirst.attendance_date  
									 and ShiftOrder = mainFirst.ShiftOrder ) ) 

	when ShiftOrder ='Last' 
	then (Select LastShiftBreakminutes 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = (Select min(Attendance_ID) 
						  from @PrelimTimekeepingTable 
						  where TimeInDiff = Min(mainFirst.TimeInDiff)
						  and attendance_date= mainFirst.attendance_date
						  and ShiftOrder = mainFirst.ShiftOrder   ) ) 			  

	else (Select LastShiftBreakminutes 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = max(mainFirst.Attendance_ID) 
		  and ShiftOrder = mainFirst.ShiftOrder 
		  )
						  
						 end) as LastShiftBreakminutes

, (Case when ShiftOrder ='First'
	   then (Select lastShiftOutDiffminutes 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = (Select min(Attendance_ID) 
									 from @PrelimTimekeepingTable 
									 where TimeOutDiff = Min(mainFirst.TimeOutDiff)
								     and attendance_date= mainFirst.attendance_date  
									 and ShiftOrder = mainFirst.ShiftOrder ) ) 

	when ShiftOrder ='Last' 
	then (Select lastShiftOutDiffminutes 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = (Select min(Attendance_ID) 
						  from @PrelimTimekeepingTable 
						  where TimeInDiff = Min(mainFirst.TimeInDiff)
						  and attendance_date= mainFirst.attendance_date 
						  and ShiftOrder = mainFirst.ShiftOrder  ) ) 			
						    
	else (Select lastShiftOutDiffminutes 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = max(mainFirst.Attendance_ID) 
		  and ShiftOrder = mainFirst.ShiftOrder 
		  )						  
						 end) as lastShiftOutDiffminutes

, (Case when ShiftOrder ='First'
	   then (Select lastShiftDuration 
			 from @PrelimTimekeepingTable 
			 where Attendance_ID = (Select min(Attendance_ID) 
									 from @PrelimTimekeepingTable 
									 where TimeOutDiff = Min(mainFirst.TimeOutDiff)
								     and attendance_date= mainFirst.attendance_date  
									 and ShiftOrder = mainFirst.ShiftOrder ) ) 

	when ShiftOrder ='Last' 
	then (Select lastShiftDuration 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = (Select min(Attendance_ID) 
						  from @PrelimTimekeepingTable 
						  where TimeInDiff = Min(mainFirst.TimeInDiff)
						  and attendance_date= mainFirst.attendance_date  
						  and ShiftOrder = mainFirst.ShiftOrder ) ) 		
						  	  
	else (Select lastShiftDuration 
		  from @PrelimTimekeepingTable 
          where Attendance_ID = max(mainFirst.Attendance_ID) 
		  and ShiftOrder = mainFirst.ShiftOrder 
		  )			

 end) as lastShiftDuration

from  @PrelimTimekeepingTable mainFirst


where


 timeouts > ScheduleTimeins 
 
 and (  
		( TimeInDiff < ShiftDuration   )
		
		 OR (  
				TimeInRemark='Early' 
			    AND not (TimeInDiff < ShiftDuration)  
				And (  
						TimeoutRemark in( 'Over-Time' ,'On-Time')  

						OR (
							TimeoutRemark = 'Under-Time' 
							and ShiftDuration > TimeOutDiff 
							) 
					)
			)
	  )


group by attendance_date, ShiftOrder


) as x


Order by attendance_date desc ,ScheduleTimeins ;

insert into @FinalsTimekeepingTable

Select attendance_date , min(ScheduleDayName) as ScheduleDayName , min(SchedDayType) as SchedDayType 
	,min(FirstTimeIn)		as TimeIns
	,min(LastTimeOut)			as TimeOuts
	,min(FirstScheduleTimeIns) as ShifIn
	,min(LastScheduleTimeOuts) as ShiftOuts


	,(Case when min(SchedDayType) in ('Rest' ,'Holiday')  then Sum(ShiftDuration)		
	   else Sum(ShiftDuration)			
		 + ( -- overtime
			Select Overtime 
			from @SemiFinalsTimekeepingTable 
			where Attendance_ID = Max(LastTime.Attendance_ID)
		   )
	     - (--late
			 + (
				Select Tardiness 
				from @SemiFinalsTimekeepingTable 
				where Attendance_ID = min(LastTime.Attendance_ID)
				)
			-- undertime
			 + (
				Select Undertime 
				from @SemiFinalsTimekeepingTable 
				where Attendance_ID = Max(LastTime.Attendance_ID)
				)
			)
	end) as Workhours

,	min(ShiftDurationOFDay) as  reqHrs

, 0 as 'Part Time hours'


,(Select Tardiness 
 from @SemiFinalsTimekeepingTable 
 where Attendance_ID = min(LastTime.Attendance_ID) and ShiftOrder = 'First'
 ) as Tardiness


 ,(Select Undertime 
 from @SemiFinalsTimekeepingTable 
 where Attendance_ID = Max(LastTime.Attendance_ID)
 ) as Undertime



 , (min(ShiftDurationOFDay) 
  -(Sum(ShiftDuration)	
	     - (--late
			 + (
				Select Tardiness 
				from @SemiFinalsTimekeepingTable 
				where Attendance_ID = min(LastTime.Attendance_ID)
				)
			-- undertime
			 + (
				Select Undertime 
				from @SemiFinalsTimekeepingTable 
				where Attendance_ID = Max(LastTime.Attendance_ID)
				)
	)
			)
 )as 'Leave w/ Pay'



 , (min(ShiftDurationOFDay) 
  -(Sum(ShiftDuration)	
	     - (--late
			 + (
				Select Tardiness 
				from @SemiFinalsTimekeepingTable 
				where Attendance_ID = min(LastTime.Attendance_ID)
				)
			-- undertime
			 + (
				Select Undertime 
				from @SemiFinalsTimekeepingTable 
				where Attendance_ID = Max(LastTime.Attendance_ID)
				)
	)
			)
 ) as 'Leave w/o Pay' 

,( Select Overtime 
from @SemiFinalsTimekeepingTable 
where Attendance_ID = Max(LastTime.Attendance_ID)
) as Overtime

 , (min(ShiftDurationOFDay) 
  -(Sum(ShiftDuration)	
	     - (--late
			 + (
				Select Tardiness 
				from @SemiFinalsTimekeepingTable 
				where Attendance_ID = min(LastTime.Attendance_ID)
				)
			-- undertime
			 + (
				Select Undertime 
				from @SemiFinalsTimekeepingTable 
				where Attendance_ID = Max(LastTime.Attendance_ID)
				)
	)
			)
 ) as Unauthorized



from @SemiFinalsTimekeepingTable LastTime

group by attendance_date
order by attendance_date desc;


--Select * from @ScheduleTimeTable;
--Select * from @PrelimTimekeepingTable;
--Select * from @SemiFinalsTimekeepingTable;
--Select * from @FinalsTimekeepingTable;

--Generate Dates
WITH Cal(n) AS
(
SELECT 0 UNION ALL SELECT n + 1 FROM Cal
WHERE n < DATEDIFF(DAY, @datesStart, @datesEnd)
),

FnlDt(d) AS
(
SELECT DATEADD(DAY, n, @datesStart) FROM Cal
),


AllDates AS
(
SELECT
[Dates] = CONVERT(DATE,d)
--,[Day] = DATEPART(DAY, d)
--,[Month] = DATENAME(MONTH, d)
--,[Year] = DATEPART(YEAR, d)
,[DayNames] = DATENAME(WEEKDAY, d)

FROM FnlDt
)


-- FakeFinal Query apply leaves
insert into @GRANDFinaleTimekeepingTable
SELECT 
   Dates	
 , DayNames as 'Day'
 , (COALESCE( SchedDayType 
			, (	
				Select min(SchedDayType)
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType in ('Rest' ,'Holiday')
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			    ) 
			, (	
				Select min(SchedDayType)
				 From @ScheduleTable 
				 where SchedType = 'Regular' 
						and SchedDayType ='Rest'
						and ScheduleDayName = dt.DayNames  
			    ) 
			, 'Absent'
		  ) )as ShiftType	

 , (ISNULL( TimeIns , '') )as TimeIns			
 , (ISNULL( TimeOuts , '') )as	TimeOuts	
 	
, (COALESCE( ShiftIns 
			 ,(	
				Select ''
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType = 'Holiday'
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			    ) 
			, (	
				Select min(ScheduleTimeins)
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType not in ('Rest','Holiday')
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			    ) 
			, (	
				Select min(ScheduleTimeins)
				 From @ScheduleTable 
				 where SchedType = 'Regular' 
						and SchedDayType <> 'Rest'
						and ScheduleDayName = dt.DayNames  
			    ) 
			, ''
		  ) )as ShiftIns
		  		
, (COALESCE( ShiftOuts	
			 ,(	
				Select ''
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType = 'Holiday'
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			    ) 	   
			, (	
				Select MAX(Scheduletimeouts)
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType not in ('Rest' ,'Holiday')
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			    ) 
			, (	
				Select MAX(Scheduletimeouts)
				 From @ScheduleTable 
				 where SchedType = 'Regular' 
						and SchedDayType <> 'Rest'
						and ScheduleDayName = dt.DayNames  
			    ) 
			, ''
		  ) )as	ShiftOuts		

 , (ISNULL(WorkHours , 0)) as	WorkHours		

 , (COALESCE(  RequiredHours 
 			 ,(	Select 0
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType = 'Holiday'
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			    ) 
			,(Select SUM(DATEDIFF(minute , ScheduleTimeins ,Scheduletimeouts))
			   From @ScheduleTable 
			   where SchedType = 'Special'
			     and SchedDayType not in ('Rest' ,'Holiday')
			     and ScheduleDayName = DayNames 
			     and Dates between SpecialdateStart and SpecialdateEnd)
			 ,(Select SUM(DATEDIFF(minute , ScheduleTimeins ,Scheduletimeouts))
			   From @ScheduleTable 
			   where SchedType = 'Regular' 
			   and SchedDayType <> 'Rest'
			   and ScheduleDayName = DayNames)
			  , 0) ) as RequiredHours
			 	
 , (ISNULL( PartTimeHours , 0) ) as PartTimeHours	
 , (ISNULL( Tardiness , 0) ) as	Tardiness		
 , (ISNULL( Undertime , 0) ) as	Undertime		


 , (COALESCE( LeaveWithPay
			 ,(	Select 0
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType = 'Holiday'
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			   ) 
			 ,(Select SUM(DATEDIFF(minute , ScheduleTimeins ,Scheduletimeouts))
			   From @ScheduleTable 
			   where SchedType = 'Special'
			     and SchedDayType not in ('Rest' ,'Holiday')
			     and ScheduleDayName = DayNames 
			     and Dates between SpecialdateStart and SpecialdateEnd)
			 ,(Select SUM(DATEDIFF(minute , ScheduleTimeins ,Scheduletimeouts))
			   From @ScheduleTable 
			   where SchedType = 'Regular' 
			   and SchedDayType <> 'Rest'
			   and ScheduleDayName = DayNames)
			  , 0) ) as LeaveWithPay	


 , (COALESCE( LeaveWithOutPay
			 ,(Select 0
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType = 'Holiday'
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			  ) 
			 ,(Select SUM(DATEDIFF(minute , ScheduleTimeins ,Scheduletimeouts))
			   From @ScheduleTable 
			   where SchedType = 'Special'
			     and SchedDayType not in ('Rest' ,'Holiday') 
			     and ScheduleDayName = DayNames 
			     and Dates between SpecialdateStart and SpecialdateEnd)
			 ,(Select SUM(DATEDIFF(minute , ScheduleTimeins ,Scheduletimeouts))
			   From @ScheduleTable 
			   where SchedType = 'Regular' 
			   and SchedDayType <> 'Rest'
			   and ScheduleDayName = DayNames)
			  , 0) ) as LeaveWithOutPay	


 , (ISNULL( Overtime , 0) ) as	Overtime	
 
 	
 , (COALESCE( Unauthorized
 			 ,(Select 0
				 From @ScheduleTable 
				 where SchedType = 'Special' 
						and SchedDayType = 'Holiday'
						and ScheduleDayName = dt.DayNames  
						and Dt.Dates between SpecialdateStart and SpecialdateEnd 
			  ) 
			 ,(Select SUM(DATEDIFF(minute , ScheduleTimeins ,Scheduletimeouts))
			   From @ScheduleTable 
			   where SchedType = 'Special'
			     and SchedDayType not in ('Rest' ,'Holiday') 
			     and ScheduleDayName = DayNames 
			     and Dates between SpecialdateStart and SpecialdateEnd)
			 ,(Select SUM(DATEDIFF(minute , ScheduleTimeins ,Scheduletimeouts))
			   From @ScheduleTable 
			   where SchedType = 'Regular' 
			   and SchedDayType <> 'Rest'
			   and ScheduleDayName = DayNames)
			  , 0) ) as Unauthorized

 , (ISNULL(Adjust.FileAdjustmentStatus , '') )as FileAdjustmentStatus
 , (ISNULL(Adjust.FileAdjustmentType , '') )as FileAdjustmentType
 , (ISNULL(Adjust.FileLeaveWithPay , '') )as leaveWithPay
 , (ISNULL(Adjust.ScheduleTimeStart , '' ) ) as ScheduleTimeStart -- let blank its time
 , (ISNULL(Adjust.ScheduleTimeEnd , '') ) as ScheduleTimeEnd -- let blank its time
 , (ISNULL(Adjust.DurationDays , '0.0') ) as DurationDays
 , (ISNULL(Adjust.Duration , '') ) as Duration
FROM AllDates Dt
left join @FinalsTimekeepingTable Finals on Finals.attendance_date = Dt.Dates
left join @FileAdjustmentsTable Adjust on Dt.Dates between Adjust.ScheduledateStart and Adjust.ScheduledateEnd
ORDER BY attendance_date desc

OPTION (MAXRECURSION 0);

insert into @HalfDayTable

Select ScheduledateStart , Sum(WithLeaved) as WithLeaved, SUM(Tardiness) as Tardiness, SUM(Undertime) as Undertime, SUM(Unauthorized) as Unauthorized

FROM(
Select * 


, (Case when TimeInRemark ='Late' and TimeInDiff < @latelimit and WithLeaved = 0 
		and ScheduleTimeins =(Select min(ScheduleTimeins) from @ScheduleTimeTable where attendance_date = ScheduledateStart)
		then TimeInDiff

		when  TimeInRemark ='Late' and WithLeaved <> ShiftDuration and AfternoonLeave = '1' and WithLeaved > '0'
		then  (Case when TimeIns > LeaveStart
					then (Case when	Datediff( minute , ScheduleTimeins, LeaveStart )  > 0 
							   and Datediff( minute , ScheduleTimeins, LeaveStart ) < @latelimit					 
							   then Datediff( minute , ScheduleTimeins, LeaveStart )		 
							   else 0 end)

					else (Case when	TimeInDiff  > 0 
							   and TimeInDiff < @latelimit	
							   and ScheduleTimeins =(Select min(ScheduleTimeins) from @ScheduleTimeTable where attendance_date = ScheduledateStart)
							   then TimeInDiff		 
							   else 0 end)								  
				   end -- Afternoon leave compute only morning session. Base on timeEnd of Filed leave
		     )


		when TimeInRemark ='Late' and WithLeaved <> ShiftDuration and MorningLeave = '1' and WithLeaved > '0'
		then (Case when (Datediff( minute ,  LeaveEnd , TimeIns ))  > 0 
		            and (Datediff( minute ,  LeaveEnd , TimeIns ))  < @latelimit					 
				   then  Datediff( minute  , LeaveEnd , TimeIns )				 
				   else 0				  
				   end -- morning leave compute only Afternoon session. Base on timeEnd of Filed leave
		     )
		else 0

end) as Tardiness


, (Case when TimeoutRemark ='Under-Time'  and WithLeaved = 0
		then (Case when TimeOutDiff > ShiftDuration then ShiftDuration else TimeOutDiff end)

		when TimeoutRemark ='Under-Time' and WithLeaved <> ShiftDuration and MorningLeave = '1' and WithLeaved > 0
		then (Case when (Datediff( minute 
								  , (Case when LeaveEnd > TimeOuts then LeaveEnd else TimeOuts end)  
								  , (Select max(Scheduletimeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart)))  > 0 		           				  			   			 
				   then  (Case when Datediff( minute  
											, (Case when LeaveEnd > TimeOuts then LeaveEnd else TimeOuts end)  
											, (Select max(Scheduletimeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart)) >ShiftDuration
						  then ShiftDuration
						  else Datediff( minute  
									   , (Case when LeaveEnd > TimeOuts then LeaveEnd else TimeOuts end)  
									   , (Select max(Scheduletimeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart) )	 end)			 
				   else 0				  
				   end -- Afternoon leave compute only morning session. Base on timeEnd of Filed leave
		     )

		when TimeoutRemark ='Under-Time' and  WithLeaved <> ShiftDuration and AfternoonLeave = '1' and WithLeaved > 0
		then (Case when (Datediff( minute ,  (Case when ScheduleTimeins > TimeOuts then ScheduleTimeins else TimeOuts end) , LeaveStart ))  > 0 		           				  			   			 
				   then (Case when Datediff( minute  , (Case when ScheduleTimeins > TimeOuts then ScheduleTimeins else TimeOuts end) , LeaveStart ) > ShiftDuration
							  then ShiftDuration
						 else Datediff( minute  , (Case when ScheduleTimeins > TimeOuts then ScheduleTimeins else TimeOuts end) , LeaveStart ) 
						 end)				 
				   else 0				  
				   end -- Afternoon leave compute only morning session. Base on timeEnd of Filed leave
		     )

	 else 0

end) as Undertime


,( (Case when TimeInRemark ='Late' and TimeInDiff >= @latelimit and WithLeaved = 0 
		then  (Case when TimeInDiff > ShiftDuration then ShiftDuration else TimeInDiff end)
		

		when  TimeInRemark ='Late' and WithLeaved <> ShiftDuration and AfternoonLeave = '1' and WithLeaved > '0'
		then  (Case when TimeIns > LeaveStart
					and	Datediff( minute , ScheduleTimeins, LeaveStart )  > 0 
		            and Datediff( minute , ScheduleTimeins, LeaveStart ) >= @latelimit					 
				   then  (Case when Datediff( minute , ScheduleTimeins, LeaveStart ) > ShiftDuration 
							   then ShiftDuration 
						  else Datediff( minute , ScheduleTimeins, LeaveStart )
						  end)			 

				   else (Case when TimeInDiff > ShiftDuration then ShiftDuration else TimeInDiff end)	
				   		  
				   end -- Afternoon leave compute only morning session. Base on timeEnd of Filed leave

		     )
		
		when TimeInRemark ='Late' and WithLeaved <> ShiftDuration and MorningLeave = '1' and WithLeaved > '0'
		then (Case when (Datediff( minute ,  LeaveEnd , TimeIns ))  > 0 
		            and (Datediff( minute ,  LeaveEnd , TimeIns )) >= @latelimit					 
				   then  (Case when Datediff( minute  , LeaveEnd , TimeIns ) > ShiftDuration 
							   then ShiftDuration 
						  else Datediff( minute  , LeaveEnd , TimeIns )
						  end)			 
				   else 0				  
				   end -- morning leave compute only Afternoon session. Base on timeEnd of Filed leave
		     )
		else 0

end) 

 + 
 
 (Case when TimeoutRemark ='Under-Time'  and WithLeaved = 0
		then  (Case when TimeOutDiff > ShiftDuration then ShiftDuration else TimeOutDiff end)

		when TimeoutRemark ='Under-Time' and WithLeaved <> ShiftDuration and MorningLeave = '1' and WithLeaved > 0
		then (Case when (Datediff( minute ,  (Case when LeaveEnd > TimeOuts then LeaveEnd else TimeOuts end) 
										  , (Select max(Scheduletimeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart)))  > 0 		           				  			   			 
				   then (Case when Datediff( minute  
											, (Case when LeaveEnd > TimeOuts then LeaveEnd else TimeOuts end)  
											, (Select max(Scheduletimeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart) ) > ShiftDuration
							  then ShiftDuration
						 else Datediff( minute  
										, (Case when LeaveEnd > TimeOuts then LeaveEnd else TimeOuts end)  
										, (Select max(Scheduletimeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart) ) end)	 
				   else 0				  
				   end -- Afternoon leave compute only morning session. Base on timeEnd of Filed leave
		     )

		when TimeoutRemark ='Under-Time' and WithLeaved <> ShiftDuration and AfternoonLeave = '1' and WithLeaved > 0
		then (Case when (Datediff( minute ,  (Case when ScheduleTimeins > TimeOuts then ScheduleTimeins else TimeOuts end) , LeaveStart ))  > 0 		           				  			   			 
				   then (Case when Datediff( minute  , (Case when ScheduleTimeins > TimeOuts then ScheduleTimeins else TimeOuts end) , LeaveStart ) > ShiftDuration 
							  then ShiftDuration
						 else Datediff( minute  , (Case when ScheduleTimeins > TimeOuts then ScheduleTimeins else TimeOuts end) , LeaveStart ) 
						 end)				 
				   else 0				  
				   end -- Afternoon leave compute only morning session. Base on timeEnd of Filed leave
		     )

	 else 0

end)




) as Unauthorized



from (

Select ScheduledateStart 
,(Select min(Timeins) from @ScheduleTimeTable where attendance_date = ScheduledateStart) as TimeIns
,(Select max(timeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart) as TimeOuts
,ScheduleTimeins
,Scheduletimeouts
,ScheduleTimeStart as LeaveStart 
,ScheduleTimeEnd as LeaveEnd

, (Case when (ScheduleTimeins between ScheduleTimeStart and ScheduleTimeEnd  OR Scheduletimeouts between ScheduleTimeStart and ScheduleTimeEnd )
		then (Case when Scheduletimeouts between ScheduleTimeStart and ScheduleTimeEnd and not ScheduleTimeins between ScheduleTimeStart and ScheduleTimeEnd
			       then (Case when DATEDIFF(MINUTE,ScheduleTimeStart,ScheduleTimeEnd) > DATEDIFF(MINUTE,ScheduleTimeins,Scheduletimeouts) 
							  then DATEDIFF(MINUTE,ScheduleTimeins,Scheduletimeouts)  
							  else DATEDIFF(MINUTE,ScheduleTimeStart,ScheduleTimeEnd)
						 end)

				   when DATEDIFF(MINUTE,ScheduleTimeins,ScheduleTimeEnd) > DATEDIFF(MINUTE,ScheduleTimeins,Scheduletimeouts) 
				   then DATEDIFF(MINUTE,ScheduleTimeins,Scheduletimeouts)

			  else DATEDIFF(MINUTE,ScheduleTimeins,ScheduleTimeEnd)  		
			  end)

		else 0

   end) as WithLeaved

   , (Case when ((Select min(ScheduleTimeins) from @ScheduleTimeTable where attendance_date = ScheduledateStart) = ScheduleTimeStart)
		then 1
		else 0
		end) as MorningLeave

, (Case when ((Select max(Scheduletimeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart)= ScheduleTimeEnd )  
		then 1
		else 0
		end) as AfternoonLeave

, ABS(DATEDIFF(MINUTE ,  (Select min(Timeins) from @ScheduleTimeTable where attendance_date = ScheduledateStart) , ScheduleTimeins))as TimeInDiff

, (case when (DATEDIFF(MINUTE , (Select min(Timeins) from @ScheduleTimeTable where attendance_date = ScheduledateStart), ScheduleTimeins) < 0)  then 'Late' 
         when (DATEDIFF(MINUTE , (Select min(Timeins) from @ScheduleTimeTable where attendance_date = ScheduledateStart), ScheduleTimeins) = 0)  then 'On-Time' 
         else 'Early' end) as TimeInRemark 

, ABS(DATEDIFF(MINUTE , (Select max(timeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart) , Scheduletimeouts)) as TimeOutDiff

,  (case when (DATEDIFF(MINUTE ,  (Select max(timeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart) , Scheduletimeouts) > 0)  then 'Under-Time' 
         when (DATEDIFF(MINUTE ,  (Select max(timeouts) from @ScheduleTimeTable where attendance_date = ScheduledateStart) , Scheduletimeouts) = 0)  then 'On-Time' 
         else 'Over-Time' end)   as TimeoutRemark 

, DATEDIFF(MINUTE ,  ScheduleTimeins , Scheduletimeouts) as ShiftDuration


from  @FileAdjustmentsTable times
left join  @ScheduleTable Sched on   Sched.ScheduleDayName =  DATENAME(dw, times.ScheduledateStart)

where FileAdjustmentType ='Leave' and DurationDays <1 and FileAdjustmentStatus ='Approved'

and ( (SchedType ='Regular' 
		and ScheduledateStart not in (Select ScheduledateStart 
									from  @FileAdjustmentsTable times
									left join  @ScheduleTable Sched on   Sched.ScheduleDayName =  DATENAME(dw, times.ScheduledateStart)								
									where SchedType ='Special' and ScheduledateStart between SpecialdateStart and SpecialdateEnd) 
	    ) 
  
 OR (SchedType = 'Special' and ScheduledateStart between SpecialdateStart and SpecialdateEnd) )

 and SchedDayType <> 'Holiday'
 ) as x 

 ) as y group by ScheduledateStart ;	


 Select 
 attendance_date		
 , ScheduleDayName		
 , SchedDayType		
 , TimeIns				
 , TimeOuts			
 , ShiftIns			
 , ShiftOuts			
 , Cast((WorkHours/60.00) as decimal(15,2)) as WorkHours		
 ,(Case when SchedDayType ='Holiday' then 0.00 else Cast((RequiredHours/60.00) as decimal(15,2))end) as RequiredHours		
 , Cast((PartTimeHours/60.00) as decimal(15,2)) as PartTimeHours
 , Cast((Tardiness/60.00) as decimal(15,2)) as Tardiness
 , Cast((Undertime/60.00) as decimal(15,2)) as Undertime
 , Cast((LeaveWithPay / (Case when RequiredHours = 0 then 1.00 else RequiredHours end)) as decimal(15,2)) as LeaveWithPay
,  Cast((LeaveWithOutPay / (Case when RequiredHours = 0 then 1.00 else RequiredHours end))as decimal(15,2)) as LeaveWithOutPay
 , Cast((Overtime/60.00) as decimal(15,2)) as Overtime
 , Cast((Unauthorized/60.00) as decimal(15,2)) as Unauthorized
 , FileleaveWithPay
 , FileadjustmentScheduleTimeStart
 , FileadjustmentScheduleTimeEnd
 , DurationDays
 , Duration 
 , FileAdjustmentStatus


 From (
 Select attendance_date		
 , ScheduleDayName		
 , SchedDayType		
 , TimeIns				
 , TimeOuts			
 , ShiftIns			
 , ShiftOuts			
 , WorkHours			
 , RequiredHours		
 , PartTimeHours		
 , (Case  when HalfDayDate is not NULL 
		  then LeaveWithTardiness
		  when FileAdjustmentStatus = 'Approved' and  FileAdjustmentType = 'Leave' and SchedDayType in ('Work' , 'Special') and (DurationDays >= 1.0)	
		  then 0
		  when Tardiness > 0 and Tardiness < @latelimit  then Tardiness 			
		  else 0 end) as Tardiness 
		 
		 			
 , (Case when  FileAdjustmentStatus = 'Approved' and  FileAdjustmentType = 'Undertime' and SchedDayType in ('Work' , 'Special')
		 then  (DATEDIFF(MINUTE,FileadjustmentScheduleTimeStart,ShiftOuts)) else 0 end ) as Undertime
		  
		 		  			
 ,  (Case when FileleaveWithPay = '1' and FileAdjustmentStatus = 'Approved' and HalfDayDate is not NULL
		  then  half.WithLeave
		  when FileleaveWithPay = '1' and FileAdjustmentStatus = 'Approved' 
		  then (RequiredHours * (Case when DurationDays > 1.0 then 1.0 else DurationDays end) )  else 0 end) as LeaveWithPay
 		
 ,  (Case when FileleaveWithPay = '0' and FileAdjustmentStatus = 'Approved' and HalfDayDate is not NULL
		  then  half.WithLeave
		 when FileleaveWithPay = '0' and FileAdjustmentStatus = 'Approved' 
		 then (RequiredHours * (Case when DurationDays > 1.0 then 1.0 else DurationDays end) ) else 0 end) as LeaveWithOutPay	

 	
 ,	(Case when FileAdjustmentStatus = 'Approved' and FileAdjustmentType = 'Overtime' and SchedDayType in ('Rest' , 'Holiday')
		  then (Case when ((Overtime)  > @whenToRestAfterMinutesForRestDayHoliday )
					 then Overtime - @overtimerestminutesForRestDayHoliday
					 else Overtime end)
		  when FileAdjustmentStatus = 'Approved' and FileAdjustmentType = 'Overtime' and SchedDayType <> 'Absent'
		  then (Case when ((Overtime - @overtimerestminutes)  >  DATEDIFF(MINUTE,FileadjustmentScheduleTimeStart,FileadjustmentScheduleTimeEnd))
					 then DATEDIFF(MINUTE,FileadjustmentScheduleTimeStart,FileadjustmentScheduleTimeEnd)
					 when (Overtime - @overtimerestminutes) < 0 
					 then  0 else Overtime - @overtimerestminutes  end)
	
					 else 0 end) 		
					 as Overtime
 			
 ,	(Case when FileAdjustmentStatus	= 'Approved' and  FileAdjustmentType = 'Leave' and DurationDays < 1.0 and HalfDayDate is not NULL
		  then LeaveWithUnauthorized
 
		  when FileAdjustmentStatus	= 'Approved' and  FileAdjustmentType = 'Leave'
		  then 0

	      when FileAdjustmentStatus	= 'Approved' and  FileAdjustmentType = 'Undertime' and SchedDayType in ('Work' , 'Special')
		  then (Case when Tardiness > 0 and Tardiness < @latelimit  
					 then Unauthorized - (Tardiness + (DATEDIFF(MINUTE,FileadjustmentScheduleTimeStart,FileadjustmentScheduleTimeEnd)))  
					 		    
					 else Unauthorized - (DATEDIFF(MINUTE,FileadjustmentScheduleTimeStart,ShiftOuts))
					 
					 end)		 
					 	 
		  when FileAdjustmentStatus <> 'Approved' OR FileAdjustmentType = 'Overtime' 
          then (Case when Tardiness > 0 and Tardiness < @latelimit
					 then Unauthorized - Tardiness										    
					 else Unauthorized end)		 
					  
          else Unauthorized end) as Unauthorized
		
 , FileAdjustmentStatus
 , FileAdjustmentType	
 , FileleaveWithPay	
 , FileadjustmentScheduleTimeStart	
 , (case when FileAdjustmentType ='Undertime' then ShiftOuts else FileadjustmentScheduleTimeEnd end) as FileadjustmentScheduleTimeEnd		
 , DurationDays
 , Duration


 from @GRANDFinaleTimekeepingTable realFinal
 left join @HalfDayTable half on half.HalfDayDate = realFinal.attendance_date 



 ) as x


ORDER BY attendance_date desc;


