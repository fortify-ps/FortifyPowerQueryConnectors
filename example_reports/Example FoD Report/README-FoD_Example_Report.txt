When the report template first loads, it will not be able to load anything because of some report parameters that need to be provided.
The problem is that you (as the user) will not know what values to apply to the parameters without first needing to look at some of the datasets in the report template. 
To get the report template working, follow these steps:
1. Provide random number for the ApplicationID, ApplicationReleaseID, and ScanID
2. Provide login credentials
3. The "Refresh" of all the datasets will fail. That's fine. Just click "Close"
4. In the upper ribbon, click on "Transform Data"
5. In the upper ribbon of the Power Query Editor window that opened, click on the drop-down menu for "Refresh Preview", then click "Refresh All".
	5-1. Most datasets will update, but not all of them. For the other datasets to refresh and start showing data, continue with the following steps.
6. From the "AllApplications" query, select one of the "applicationId" values, and copy that value to the "ApplicationId" Parameter
7. From the "AllReleases" query, select one of the "releaseId" values, and copy that value to the "ApplicationReleaseId" Parameter
8. From the "AllScans" query, select one of the "scanId" values, and copy that value to the "ScanID" Parameter
9. In the upper ribbon of the Power Query Editor window that opened, click on the drop-down menu for "Refresh Preview", then click "Refresh All".
	9-1. If after a few seconds, you still see the yellow triangle on some of the tables/queries, just click on them and it and you should see data populate in the table and the icon change
10. Once you see all the yellow triangle icons go away, click on "Close & Apply" in the upper left corner of the power query editor.
11. From here the data will start to load and you should see the charts start to populate with data.
	11-1. If in the "Load" windows, there is an error for the "ScanSummary" query, just ignore it, and click close.
