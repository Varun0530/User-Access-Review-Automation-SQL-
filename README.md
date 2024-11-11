## Overview
User Access Review Automation is an SQL-based project designed to automate the process of auditing user access in an organization. It generates insightful reports to help identify active users, inactive accounts, and discrepancies in user-role assignments. These reports are customizable and scheduled to be generated automatically for compliance and periodic review cycles.

This project showcases the use of SQL for:

-) Data integration across multiple access-related tables.
-) Automation of data processing and report generation.
-) Identification of security risks, such as inactive accounts and mismatched roles.

## Features
### Active User Reports:

-) Categorizes active users based on their roles and departments.
-) Provides insights into how roles are distributed across departments.
### Inactive Accounts Report:

-) Identifies users who haven’t logged in for a specified period (default: 90 days).
-) Helps administrators review and deactivate dormant accounts.
### Discrepancy Reports:

-) Highlights user-role assignments that do not align with department or project requirements.
-) Aids in rectifying unauthorized or incorrect role assignments.
### Automation:

-) Automates the generation of reports at monthly or quarterly intervals.
-) Saves reports as CSV files for easy review and integration with other tools.
### Customizable:

-) SQL queries are modular and can be adapted for specific organizational needs.

## Key Metrics
1) Active Users by Role:

-) Grouped by department and role.
2) Inactive Accounts:

-) Users who haven’t logged in for over 90 days.
3) Discrepancies in Role Assignments:

-)Roles assigned to users that don’t align with department or project policies.
