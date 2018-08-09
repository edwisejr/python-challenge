import os
import csv

vote_data= os.path.join("Resources","election_data.csv")

winner = ''
winning_vote = 0
votes = 0
candidates = []
candidates_votes = []
i = 0

with open(vote_data, newline="") as csvfile:
    csvreader = csv.reader(csvfile, delimiter=",")
    csvheader = next(csvfile)
    for row in csvreader:
        votes +=1
        if row[2] not in candidates:
            candidates.append(row[2])

for i in range(len(candidates)):
    vote_cnt = 0
    with open(vote_data, newline="") as csvfile:
        csvreader = csv.reader(csvfile, delimiter=",")
        csvheader = next(csvfile)
        for row in csvreader:
            if row[2] ==(candidates[i]):
                vote_cnt+=1
    candidates_votes.append((candidates[i])+": "+'{:,.3f}%'.format((vote_cnt)/(votes)*100)+" "+'({:,})'.format(vote_cnt))
    if vote_cnt > winning_vote:
        winning_vote = vote_cnt
        winner = (candidates[i])
    i += 1
        
Election_Report =(
""
+"\nElection Results"
+"\n------------------------"
+"\nTotal Votes: "+'{:}'.format(votes)
+"\n------------------------"
+'\n'+'\n'.join(candidates_votes)
+"\n------------------------"
+"\nWinner: "+str(winner)
+"\n------------------------")

print(Election_Report)

f = open('Election_Report.txt','w')
f.write(Election_Report)
f.close()