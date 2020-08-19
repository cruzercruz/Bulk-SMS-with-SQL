USE [YOUR-SCHEMA]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tanu Wongkalasin
-- Create date: 22/07/2020
-- Description:	Send message with BulkSMS API
-- How to use : exec SendSMS '66xxxxxxx' , 'สวัสดี'
-- =============================================
ALTER PROCEDURE [dbo].[SendSMS]
	@pPhoneNumber as varchar(15),
	@pMessage as varchar(150)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @Object AS INT;
	DECLARE @ResponseText AS VARCHAR(8000);
	DECLARE @Body AS VARCHAR(8000) = 
	'{
		"TokenID":"' + CAST(NEWID() AS VARCHAR(36)) + '",
		"PhoneNumber":"' + @pPhoneNumber + '",
		"MessageDetail":{
			"Message":"' + @pMessage + '",
			"LinkMessage":[
				{
					"Name":"",
					"Link":"",
					"Display":""
				},
				{
					"Name":"",
					"Link":"",
					"Display":""
				}
			]
		},
		"RequestBy":"SP"
	}'  

	EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
	EXEC sp_OAMethod @Object, 'open', NULL, 'post','<YOUR-BULK-SMS-API>', 'false'

	EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
	EXEC sp_OAMethod @Object, 'send', null, @body

	EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
	SELECT @ResponseText

	EXEC sp_OADestroy @Object
END
