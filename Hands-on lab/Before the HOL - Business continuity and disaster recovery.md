![](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/master/Media/ms-cloud-workshop.png "Microsoft Cloud Workshops")

<div class="MCWHeader1">
Business continuity and disaster recovery
</div>

<div class="MCWHeader2">
Before the hands-on lab setup guide
</div>

<div class="MCWHeader3">
September 2018
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2018 Microsoft Corporation. All rights reserved.

**Contents**

<!-- TOC -->

- [Business continuity and disaster recovery before the hands-on lab setup guide](#business-continuity-and-disaster-recovery-before-the-hands-on-lab-setup-guide)
    - [Requirements](#requirements)
    - [Before the hands-on lab](#before-the-hands-on-lab)
        - [Task 1: Create a virtual machine to execute the lab](#task-1-create-a-virtual-machine-to-execute-the-lab)
        - [Task 2: Download hands-on support files to LABVM](#task-2-download-hands-on-support-files-to-labvm)
        - [Task 3: Install SQL Server Express on LABVM](#task-3-install-sql-server-express-on-labvm)
        - [Task 4: Create the resource groups](#task-4-create-the-resource-groups)

<!-- /TOC -->

# Business continuity and diisaster recovery before the hands-on lab setup guide 

## Requirements

-  An Azure Subscription with full access to the environment.

## Before the hands-on lab

Duration: 20 minutes

### Task 1: Create a virtual machine to execute the lab

1.  Launch a browser and navigate to the Azure Global portal at <https://portal.azure.com>. Once prompted, login with your Microsoft Azure credentials. If prompted, choose whether your account is an organization account or just a Microsoft Account.

2.  Select on **+Create a resource**, and in the search box enter **Visual Studio Community 2017 on Windows Server 2016 (x64)** and press enter. Select the Visual Studio Community 2017 image running on Windows Server 2016 and with the latest update.

3.  In the returned search results select the image name.

![In the Everything blade, Visual Studio Community 2017 on Windows Server 2016 (x64) is selected.](images/Setup/image5.png "Everything blade")
.
4.  Select **Create**

5.  Set the following configuration on the Basics tab and select **OK**:

    -   **Name**: LABVM

    -   **VM disk type**: SSD

    -   **User name**: mcwadmin

    -   **Password:** demo\@pass123

    -   **Subscription**: If you have multiple subscriptions choose the subscription to execute your labs in.

    -   **Resource Group**: BCDRLabRG

    -   **Location**: Choose the closest Azure region to you.

    ![Fields in the Basics blade are set to the previously defined settings.](images/Setup/image6.png "Basics blade")

6.  Choose the **D2S\_V3 Standard** instance size on the Size blade.

>**Note:** If the Azure Subscription you are using has limits on the number of cores you may wish to choose DS1\_V2.

7. Click **Next: Disks**.

    ![Next: Disks Button](images/Setup/image7.png "Disks button")

8.  Select **Premium SSD** then **Next: Networking>**.

    ![Networking](images/Setup/image8.png "Next: Networking>")

9.  Click Allow selected ports and then choose RDP (3389) from the **Select public inbound ports dropdown**.  This will open connections
    from the internet to the VM.
    
    ![Select public inbound ports dropdown with RDP (3389) selected](images/Setup/image27.png "Select public inbound ports dropdown")

10.  Click **Review + create**.

     ![Review + create button](images/Setup/image28.png "Review + create button")
    
11. After the validation click Create. The deployment should begin provisioning. It may take 10+ minutes for the virtual machine to complete provisioning.

   ![Screenshot of the Deploying Visual Studio Community 2017 icon.](images/Setup/image9.png "Deploying Visual Studio icon")

>**Note:** Please wait for the LABVM to be provisioned prior to moving to the next step.

11. Move back to the Portal page on your local machine and wait for **LABVM** to show the Status of **Running**. Select **Connect** to establish a new Remote Desktop Session.

    ![The Connect button is called out on the LABVM Virtual Machine blade top menu.](images/Setup/image10.png "LABVM Virtual Machine blade")

12. Depending on your remote desktop protocol client and browser configuration you will either be prompted to open an RDP file, or you will need to download it and then open it separately to connect.

13. Log in with the credentials specified during creation:

    -   **User**: mcwadmin

    -   **Password**: demo\@pass123

    ![Credentials fields are called out in the Windows Security Credentials section.](images/Setup/image11.png "Windows Security Credentials section")

14. You will be presented with a Remote Desktop Connection warning because of a certificate trust issue. Select **Yes** to continue with the connection.

    ![The Remote Desktop Connection Warning dialog box displays, letting you know that the remote computer's identity cannot be verified, and asking if you want to connect anyway.](images/Setup/image12.png "Remote Desktop Connection Warning dialog box")

15. When logging on for the first time, you will see a prompt on the right asking about network discovery. Select **No**.

    ![The Networks pop-up displays, asking if you want to turn on network discovery.](images/Setup/image13.png "Networks pop-up")

16. Notice that Server Manager opens by default. On the left, select **Local Server**.

    ![On the Server Manager menu, Local Server is selected.](images/Setup/image14.png "Server Manager menu")

17. On the right side of the pane, select **Off** by **IE Enhanced Security Configuration**.

    ![IE Enhanced Security Configuration is set to Off, and is selected.](images/Setup/image15.png "IE Enhanced Security Configuration option")

18. Change to **Off** for Administrators and Users then select **OK**.

    ![In the Internet Explorer Enhanced Security Configuration dialog box, Administrators is set to Off, and Users is set to Off.](images/Setup/image16.png "Internet Explorer Enhanced Security Configuration dialog box")

### Task 2: Download hands-on support files to LABVM

1.  Download the zipped Hands-on Lab Step by Step student files at this link:

    <https://www.dropbox.com/s/mfy0hx84ljie3rq/StudentFiles.zip?dl=1>

2.  Extract the files to a directory here **C:\\HOL** on LABVM.

### Task 3: Install SQL Server Express on LABVM

1.  From within LABVM open Internet Explorer and browse to the following URL:

    <https://www.microsoft.com/en-US/sql-server/sql-server-downloads>

2.  Click **Download now** under the Express edition.

    ![On the Download SQL Server 2017 for Windows webpage, Express edition is selected for download.](images/Setup/image17.png "Download SQL Server 2017 for Windows webpage")

3.  Click **Run**.

    ![Next to the message asking if you want to run or save SQLServer 2017, Run is selected.](images/Setup/image18.png "Run button")

4.  When the installer starts, click **Basic**.

    ![Basic is selected in the SQL Server 2017 Express Edition Installer wizard.](images/Setup/image19.png "SQL Server 2017 Express Edition Installer")

5.  Accept the other defaults in the install wizard until SQL starts to install.

6.  Once the install completes, click the **Install SSMS** button. This will webpage where you can download and install SQL Server Management Studio.

    ![On the SQL Server 2017 Express Edition Installation Complete page, the Install SSMS button is selected.](images/Setup/image20.png "SQL Server 2017 Express Edition Installation Complete page")

7.  Click the **Download SQL Server Management Studio 17.X** link. When prompted click **Run**.

    ![On the Download SSMS page, the link to Download SQL Server Management Studio 17.5 is selected.](images/Setup/image21.png "Download SSMS page")

8.  Click **Install**.

    ![On the Install Microsoft SQL Server Managmeent Studio Welcome page, the Install button is selected.](images/Setup/image22.png "Microsoft SQL Server Managmeent Studio Welcome page")

9.  Click **Close**.

### Task 4: Create the resource groups

In this task, you will select a **Primary** and **Secondary** Azure Region that will be used for the remainder of the HOL. The **Primary** region should be able to **support V3 virtual machine** sizes, and then you should select the **Secondary** region based on the region pair assigned by Microsoft. Use the Products available by region webpage to determine your **Primary** site: <https://azure.microsoft.com/en-us/regions/services/>. Once you have selected the Primary site, then review the BCDR page to find your Primary Site's Region Pair: <https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions>.

>**Note:** The examples in this HOL Guide use these regions: **Primary:** East US 2 and **Secondary**: Central US.

1.  From the **LABVM**, open Internet Explorer and connect to the Azure portal at: <https://portal.azure.com>.

2.  Select **Resource groups**, the select **+Add**.

    ![On the Azure Portal Resource groups blade, the Add button is selected.](images/Setup/image23.png "Azure Portal, Resource groups blade")

3.  Complete the **Resource group** blade using the following inputs and select **Create**:

    -   **Resource group name**: BCDRIaaSPrimarySite

    -   **Subscription**: Select your Subscription.

    -   **Resource group location**: Select a Region for the Primary location.

        ![In the Resource group blade, fields are set to the previously defined settings.](images/Setup/image24.png "Resource group blade")

>**Note:** It's very important for you to use these exact names. Changing the names of the Resource groups will impact the HOL setup and could cause you not to be able to complete the lab.

4.  Select **Resource groups**, then select **+Add**

    ![On the Azure Portal Resource groups blade, the Add button is selected.](images/Setup/image23.png "Azure Portal, Resource groups blade")

5.  Complete the **Resource group** blade using the following inputs and select **Create**.

    -   **Resource group name**: BCDRIaaSSecondarySite

    -   **Subscription**: Select your Subscription.

    -   **Resource group location**: Select a Region for the Secondary location.

        ![In the Resource group blade, fields are set to the previously defined settings.](images/Setup/image25.png "Resource group blade")

6.  Continue to add resource groups to support the HOL.

|    |            |       
|----------|:-------------:|
| **Resource Group Name** | **Location** |
| **BCDRAzureAutomation** | Any available site other than your Primary or Secondary |
| **BCDRAzureSiteRecovery** | Secondary |
| **BCDROnPremPrimarySite** | Primary |
| **BCDRPaaSPrimarySite** | Primary |
| **BCDRPaaSSecondarySite** | Secondary |

7.  Once all the resource groups have been created, you should review all the resource groups for this HOL. **It is critical to ensure that the spelling is correct and that they are in the correct Azure Regions (Primary or Secondary)**.

>**Note:** If for some reason there is an error, you should delete the resource group with the error and recreate it.

8.  Here is the Azure Portal with each of the resource groups created in the correct Azure Region:

    ![In the Resource groups blade, various resource groups and their locations are listed.](images/Setup/image26.png "Resource groups blade")

You should follow all steps provided *before* attending the Hands-on lab.
