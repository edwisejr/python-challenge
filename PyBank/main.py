import os
import csv

budget = os.path.join("Resources","budget_data.csv")
month = []
total = 0
Financial_Analysis =''
changes =[]
change =0.0
month2 = 0.0
month1 = 0.0
avg_change = 0.0
change_total = 0.0
max_month_change = 0.0
min_month_change = 0.0
maxmonth =''
minmonth =''

with open(budget, newline="") as csvfile:
    csvreader = csv.reader(csvfile, delimiter=",")
    csvheader = next(csvfile)
    for row in csvreader:
        month.append(row[0])
        month_tuple = tuple(month)
        month_cnt = len(month_tuple)
        total += int(row[1])
        month1 = row[1]
        change = float(month1) - float(month2)
        changes.append(int(change))
        change_total= change  + change_total
        month2 = month1
        if change > max_month_change:
            max_month_change = change
            max_month =(row[0])
        if change < min_month_change:
            min_month_change = change
            min_month =(row[0])
        
avg_change = (change_total-changes[0])/(month_cnt-1)

Financial_Analysis =  (
    ""+
    "\nFinancial Analysis"+
    "\n---------------------------------------------------"
    "\nTotal Months: " +str((month_cnt))+
    "\nTotal: "+ '${:,}'.format(total)+
    "\nAverage Change: "+ '${:,.2f}'.format(avg_change)+
    "\nGreatest Increase in Profits: "+(max_month) +' (${:,})'.format(max_month_change)+
    "\nGreatest Decrease in Profits: "+(min_month) +' (${:,})'.format(min_month_change)
    )

print(Financial_Analysis)

f = open('Financial_Analysis.txt','w')
f.write(Financial_Analysis)
f.close()