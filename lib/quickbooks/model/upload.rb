module Quickbooks
  module Model
    class Upload < BaseModel
      xml_convention :camelcase

      #xml_accessor :attache, :as => Attachable

    end
  end
end

=begin

Response XML:

<IntuitResponse xmlns="http://schema.intuit.com/finance/v3" time="2014-08-18T09:58:04.583-07:00">
	<AttachableResponse>
		<Attachable domain="QBO" sparse="false">
			<Id>2700000000001439108</Id>
			<SyncToken>0</SyncToken>
			<MetaData>
				<CreateTime>2014-08-18T09:58:06-07:00</CreateTime>
				<LastUpdatedTime>2014-08-18T09:58:06-07:00</LastUpdatedTime>
			</MetaData>
			<FileName>monkey.jpg</FileName>
			<FileAccessUri>/v3/company/1002341430/download/2700000000001439108</FileAccessUri>
			<TempDownloadUri>https://intuit-qbo-prod-30.s3.amazonaws.com/1002341430%2Fattachments%2Fmonkey.jpg?Expires=1408381986&amp;AWSAccessKeyId=AKIAJEXDXKNYCBUNCCCQ&amp;Signature=WOVACYm6zi1rM5EGZRq3d3AMSM0%3D</TempDownloadUri>
			<Size>105840</Size>
			<ContentType>image/jpeg</ContentType>
			<ThumbnailFileAccessUri>/v3/company/1002341430/attachable-thumbnail/2700000000001439108</ThumbnailFileAccessUri>
		</Attachable>
	</AttachableResponse>
</IntuitResponse>

=end
