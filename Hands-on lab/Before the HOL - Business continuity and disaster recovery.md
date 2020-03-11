![Microsoft Cloud Workshops](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/master/Media/ms-cloud-workshop.png "Microsoft Cloud Workshops")

<div class="MCWHeader1">
Business continuity and disaster Recovery
</div>

<div class="MCWHeader2">
Before the hands-on lab setup guide
</div>

<div class="MCWHeader3">
March 2020
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2020 Microsoft Corporation. All rights reserved.

**Contents**

<!-- TOC -->

- [Business continuity and disaster recovery before the hands-on lab setup guide](#business-continuity-and-disaster-recovery-before-the-hands-on-lab-setup-guide)
  - [Requirements](#requirements)
  - [Before the hands-on lab](#before-the-hands-on-lab)
    - [Task 1: Create a virtual machine to execute the lab](#task-1-create-a-virtual-machine-to-execute-the-lab)
    - [Task 2: Install Azure PowerShell 'Az' commands](#task-2-install-azure-powershell-az-commands)
    - [Task 3: Download hands-on support files to LABVM](#task-3-download-hands-on-support-files-to-labvm)
    - [Task 4: Install SQL Server Express on LABVM](#task-4-install-sql-server-express-on-labvm)
    - [Task 5: Create Azure Resource Groups](#task-5-create-azure-resource-groups)

<!-- /TOC -->

# Business continuity and disaster recovery before the hands-on lab setup guide

## Requirements

- Laptop or tablet, internet browser, reliable and available internet connection

- Azure Subscription with full access to the environment.

## Before the hands-on lab

Duration: 20 minutes

### Task 1: Create a virtual machine to execute the lab

1. Launch a browser and navigate to the Azure Global portal at <https://portal.azure.com>. Once prompted, login with your Microsoft Azure credentials. If prompted, choose whether your account is an Organization or Microsoft account.

2. In the Azure Portal, select the **+Create a resource** tile beneath Azure services. In the search box start typing **Visual Studio Community** and press **Enter**. Select the **Visual Studio 2019 Latest** tile, then choose the **Visual Studio 2019 Community (latest release) on Windows Server 2019 (x64)** software plan.

    > **Note**: Ensure that you select the exact image name identified above. Failure to do so may result in problems successfully completing the BCDR HOL.

    ![In the Visual Studio Community 2019 Latest screen, Visual Studio Community (latest release) on Windows Server 2019 (x64) is selected from the software plan dropdown list.](images/Setup/image5.png "Marketplace blade")

3. Select **Create**.

4. Apply the following configuration items in the **Project details** section of the **Basics** tab:

    - **Subscription**: If you have multiple subscriptions, choose the appropriate subscription in which to conduct the lab.
    - **Resource Group**: Create a new resource group named `BCDRLabRG`
    - **Virtual machine name**: `LABVM`
    - **Size**: Select **Change size** and choose the **Standard D4s v3** instance size.
    - **Region**: Choose the Azure region closet to you.

    ![Project details fields in the Basics tab are set to the previously defined values.](images/Setup/image6.png "Project details in Basics tab")

    > **Note:** If the Azure Subscription you are using has limits on the number of cores, you may wish to choose DS1\_V2.

5. Continuing on the **Basics** tab, define **Administrator account** settings as follows:

    - **Username**: `mcwadmin`
    - **Password:** `demo@pass123`

    ![Administrator account fields in the Basics tab are set to the previously defined values. The eyeball icon within the Confirm password textbox is highlighted.](images/Setup/image6point5.png "Administrator account settings in the Basics tab")

    > **Note:** You may want to select the small eyeball icon in the password fields to ensure you've entered them correctly.
  
6. In the **Inbound port rules** section of the **Basics** tab, select to **Allow selected ports** and then choose **RDP (3389)** from the **Select  inbound ports** dropdown list.  This will enable remote desktop connections from the internet to LABVM.

    ![Inbound port rules fields in the Basics tab are set to the previously defined values.](images/Setup/images6point75.png "Inbound port rules settings in the Basics tab")

7. Select **Next: Disks**.

    ![View of the Next: Disks Button.](images/Setup/image7.png "Disks button")

8. Select **Premium SSD**.

    ![Premium SSD is selected for OS disk type.](images/Setup/image8.png "Disks Tab")

9. Select **Review + create**.

    ![View of the Review + create button.](images/Setup/image28.png "Review + create button")

10. After validation, select **Create**. The Azure deployment should begin provisioning. It may take 10+ minutes for the virtual machine provisioning to complete.

    ![Screenshot of the Deploying Visual Studio Community 2019.](images/Setup/image9.png "Your deployment is underway")

    > **Note:** Please wait for the LABVM to be completely provisioned prior to moving to the next step.

11. Move back to the Portal page on your local machine and wait for **LABVM** to show the Status of **Running**. Select **Connect** to establish a new Remote Desktop Session.

    ![The Connect button is called out on the LABVM Virtual Machine blade top menu.](images/Setup/image10.png "LABVM Virtual Machine blade")

12. Choose **Download RDP File**, then open the `.rdp` file to connect to the VM.

13. Log in to your newly created LABVM with the credentials specified during creation:

    - **User**: `mcwadmin`

    - **Password**: `demo@pass123`

    ![A Windows Security modal window is displayed with the credentials fields populated with the previous values.](images/Setup/image11.png "Windows Security Credentials modal")

14. You will be presented with a Remote Desktop Connection warning because of a certificate trust issue. Select **Yes** to continue with the connection.

    ![The Remote Desktop Connection Warning dialog box displays, letting you know that the remote computer's identity cannot be verified, and is asking if you want to connect anyway. The Yes button is selected.](images/Setup/image12.png "Remote Desktop Connection Warning dialog box")

15. When logging in for the first time, you may be prompted about Windows network discovery. Select **No**.

    ![The Networks pop-up displays, asking if you want to turn on network discovery. The No button is selected.](images/Setup/image13.png "Networks pop-up")

16. Notice that Server Manager opens by default. On the left, select **Local Server** (LABVM).

    ![On the Server Manager menu, Local Server is selected.](images/Setup/image14.png "Server Manager menu")

17. On the right side of the pane, select **Off** next to **IE Enhanced Security Configuration**.

    ![The IE Enhanced Security Configuration field is highlighted and is set to Off.](images/Setup/image15.png "IE Enhanced Security Configuration option")

18. Change to **Off** for both Administrators and Users then select **OK**.

    ![In the Internet Explorer Enhanced Security Configuration dialog box, Administrators is set to Off, and Users is set to Off.](images/Setup/image16.png "Internet Explorer Enhanced Security Configuration dialog box")

### Task 2: Install Azure PowerShell 'Az' commands

1. Open a PowerShell command-line (be sure to *Run as Administrator*).

2. In the PowerShell command-line, run the following command to install the new Azure PowerShell 'Az' commands:

    ```PowerShell
    Install-Module -Name Az -AllowClobber
    ```

    > **Note**: If you have any errors installing the Azure 'Az' PowerShell commands, then reference the following article:
    > <https://azure.microsoft.com/en-us/blog/how-to-migrate-from-azurerm-to-az-in-azure-powershell/>.

### Task 3: Download hands-on support files to LABVM

1. Download the zipped Hands-on Lab Step by Step student files at the following link: [Student Files](https://github.com/Microsoft/MCW-Business-continuity-and-disaster-recovery/blob/master/Hands-on%20lab/StudentFiles/StudentFiles.zip?raw=true).

2. Extract the files to a directory here **C:\\HOL** on LABVM.

### Task 4: Install SQL Server Express on LABVM

1. From within LABVM, open Internet Explorer and browse to the following URL:

    <https://www.microsoft.com/en-US/sql-server/sql-server-downloads>

2. Select **Download now** under the Express edition of SQL.

    ![On the SQL Server webpage, the Download now button is selected beneath the Express edition.](images/Setup/image17.png "SQL Server webpage")

3. Choose **Run** when prompted after downloading.

    ![A download dialog prompts what you would like to do with the download. The Run button is highlighted.](images/Setup/image18.png "Run button")

4. When the installer starts, select **Basic**.

    ![The Basic installation tile is selected in the SQL Server Express Edition installer.](images/Setup/image19.png "SQL Server Express Edition Installer")

5. Accept the other defaults in the install wizard until SQL starts to install. This may take 5-10 minutes to complete.

6. Once the install completes, select the **Install SSMS** button. This will take you to a webpage where you can download and install SQL Server Management Studio (SSMS).

    ![On the SQL Server Express Edition Installation Complete page, the Install SSMS button is selected.](images/Setup/image20.png "SQL Server 2017 Express Edition Installation Complete page")

7. Select the **Download SQL Server Management Studio** link. When prompted, choose **Run**.

    ![On the Download SSMS page, the link to Download SQL Server Management Studio is selected.](images/Setup/image21.png "Download SSMS page")

8. Select **Install** when prompted to begin installing SSMS. This may take 5-10 minutes to complete.

    ![On the Install Microsoft SQL Server Management Studio Welcome page, the Install button is selected.](images/Setup/image22.png "Microsoft SQL Server Management Studio Welcome page")

9. Select **Close** when the installation of SMSS is complete.

10. Select **Close** on the SQL Express Edition setup wizard.

### Task 5: Create Azure Resource Groups

In this task, you will select **Primary** and **Secondary** Azure regions that will be used for the remainder of the BCDR HOL. The **Primary** region should be able to **support V3 virtual machine** sizes, and then you should select the **Secondary** region based on the region pair assigned by Microsoft. Use the Products available by region webpage to determine your **Primary** site: <https://azure.microsoft.com/en-us/regions/services/>. Once you have selected the Primary site,  review the BCDR page to find your Primary Site's Region Pair: <https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions>.

> **Note:** The examples in this HOL Guide use the following regions: **Primary:** East US 2 and **Secondary**: Central US. For this lab be sure to use these regions as they are validated to work with all the Azure features / services used throughout this lab.

1. From the **LABVM**, open Internet Explorer and connect to the Azure portal at: <https://portal.azure.com>.

2. Select **Resource groups**, then select **+Add**.

    ![On the Azure Portal Resource groups blade, the Add button is selected.](images/Setup/image23.png "Azure Portal, Resource groups blade")

3. Complete the **Resource group** blade using the following inputs and select **Review + Create** and **Create**:

    - **Resource group name**: `BCDRIaaSPrimarySite`
    - **Subscription**: Select your subscription.
    - **Resource group location**: **East US 2** (Primary region)

    ![In the Resource group blade, fields are set to the previously defined settings.](images/Setup/image24.png "Resource group blade")

    > **Note:** It's very important to use these exact names. Changing the names of the Resource groups will impact the HOL setup and could cause you not to be able to complete the lab.

4. Select **Resource groups**, then select **+Add**.

    ![On the Azure Portal Resource groups blade, the Add button is selected.](images/Setup/image23.png "Azure Portal, Resource groups blade")

5. Complete the **Resource group** blade using the following inputs and select **Review + Create** and **Create**.

    - **Resource group name**: `BCDRIaaSSecondarySite`
    - **Subscription**: Select your subscription.
    - **Resource group location**: **Central US** (Secondary region)

        ![In the Resource group blade, fields are set to the previously defined settings.](images/Setup/image25.png "Resource group blade")

6. Continue to add the resource groups below to support the HOL:

    | **Resource Group Name** | **Location** |
    |----------|-------------|
    | **BCDRAzureAutomation** | Any available site (other than your Primary or Secondary) regions |
    | **BCDRAzureSiteRecovery** | **Central US** (Secondary) |
    | **BCDROnPremPrimarySite** | **East US 2** (Primary) |
    | **BCDRPaaSPrimarySite** | **East US 2** (Primary) |
    | **BCDRPaaSSecondarySite** | **Central US** (Secondary) |

7. Once all the resource groups have been created, review all the resource groups for this HOL. **It is critical to ensure that the spelling is correct and that they are in the correct Azure Regions (Primary or Secondary)**.

    > **Note:** If for some reason there is an error, delete the erroneous resource group  and recreate it.

8. Here is the Azure Portal with each of the resource groups created in the correct Azure Region:

    ![In the Resource groups blade, various resource groups and their locations are listed.](images/Setup/image26.png "Resource groups blade")

You should follow all steps provided *before* starting the Hands-on Lab.
