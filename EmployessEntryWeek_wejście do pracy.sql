SELECT 
    Lastname, 
    Firstname,
	Profession,
    --EntryDate, 
    --EntryDateValidated, 
    --ExitDate, 
    CAST(SUM(DATEDIFF(MINUTE, EntryDateValidated, ExitDate)) / 60.0 AS decimal(5, 2)) AS TotalTimeDifferenceValidated,
    --CAST(CAST(SUM(DATEDIFF(MINUTE, EntryDateValidated, ExitDate)) - 30 AS decimal(10,2))/60.0 AS decimal(5, 2)) AS TimeWithoutBrekfastBreak

	CAST(CAST(SUM(DATEDIFF(MINUTE, EntryDateValidated, ExitDate)) AS decimal(10,2))/60.0 AS decimal(5, 2)) - 
        (DATEDIFF(DAY, MIN(EntryDateValidated), MAX(EntryDateValidated)) + 1) * 0.5 AS TimeWithoutBrekfastBreak

FROM (
    SELECT  
        [IdEmployeeEntry],
        [dbo].[EmployeeEntry].[IdEmployee],
        dbo.Employee.Lastname,
        dbo.Employee.Firstname,
        [dbo].[Employee].Profession,
        [EntryDate],
        CASE 
            WHEN DATEPART(hour, [dbo].[EmployeeEntry].EntryDate) >= 5 AND DATEPART(hour, [dbo].[EmployeeEntry].EntryDate) < 6 
                THEN FORMAT([dbo].[EmployeeEntry].EntryDate, 'yyyy-MM-dd') + ' 6:00'
            ELSE FORMAT([dbo].[EmployeeEntry].EntryDate, 'yyyy-MM-dd HH:mm') 
        END AS EntryDateValidated,
        [ExitDate],
        [dbo].[EmployeeEntry].[IsAutomaticallyLogout],
        [dbo].[EmployeeEntry].[IsDelayed]
    FROM [ERP].[dbo].[EmployeeEntry] 
        INNER JOIN [ERP].[dbo].[Employee]
        ON [ERP].[dbo].[EmployeeEntry].IdEmployee = [ERP].[dbo].[Employee].IdEmployee
    WHERE EntryDate > '2023-03-20' AND EntryDate < '2023-03-27'
        
		AND [dbo].[Employee].[IsProductionWorker] = 1
        AND [dbo].[EmployeeEntry].IsManual = 0
		--AND ([dbo].[Employee].Profession = 'Automatyk' OR [dbo].[Employee].Profession = 'Œlusarz Mechanik')
		--AND ([dbo].[Employee].Lastname = 'Grubert' OR [dbo].[Employee].Lastname = 'Hess' OR [dbo].[Employee].Lastname = 'Karpiak' OR [dbo].[Employee].Lastname = 'Krawczyk')
) AS sub
GROUP BY IdEmployee, Lastname, Firstname, Profession
ORDER BY Lastname ASC ;
