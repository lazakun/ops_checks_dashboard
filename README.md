Project Task:
- a dashboard that flags operational anomalies on a daily basis
- a centralized location should be created to setup logic to detect these operational anomalies
- location (ops_check table) should incorporate:
 - ops check description
 - ops check category
 - ops check logic (scripts or stored procedure)
 - ops check threshold (expected min and max value)
 - ops check runtime (or schedule)
 - ops check owner
 - ops check status (active or inactive)
 - ops check documentation
- dashboard should show main run (that run through all the ops check once based on the schedule of each ops check configured in the ops_check table)
- dashboard should show rerun (thar run against every ops check that flagged captured by the main run)
- dashboard should show last 7 days result for both main run and rerun


Proposed Solution
- SQL jobs would be created to schedule and execute the ops check runs
- Power BI with the aid of conditional formatting would be used to visualize the dashboard

scripts or store procedure should have the following ouput format
![image](https://github.com/lazakun/ops_checks_dashboard/assets/100403369/794d8436-812e-411d-b67c-cca078e1f454)

