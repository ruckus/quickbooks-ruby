module Quickbooks
  module Service
    class Upload < BaseService

      XML_NODE = "AttachableResponse"

      # path_to_file: String - path to file
      # mime_type: String - the MIME type of the file, e.g. image/jpeg
      # attachable: Quickbooks::Model::Attachable meta-data details, can be null
      def upload(path_to_file, mime_type, attachable = nil)
        url = url_for_resource("upload")
        uploadIO = class_for_io.new(path_to_file, mime_type)
        response = do_http_file_upload(uploadIO, url, attachable)
        prefix = "AttachableResponse/xmlns:Attachable"
        if response.code.to_i == 200
          model.from_xml(parse_singular_entity_response(model, response.plain_body, prefix))
        else
          nil
        end
      end

      def class_for_io
        oauth.is_a?(OAuth2::AccessToken) ? Faraday::UploadIO : UploadIO
      end

      def download(uploadId)
        url = url_for_resource("download/#{uploadId}")
        do_http_get(url, {}, headers)
      end

      private

      def model
        Quickbooks::Model::Attachable
      end

    end
  end
end
