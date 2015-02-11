module Quickbooks
  module Service
    class Upload < BaseService

      def perform(path_to_file, mime_type)
        url = url_for_resource("upload")
        uploadIO = UploadIO.new(path_to_file, mime_type)
        do_http_file_upload(uploadIO, url)
      end

      def download(uploadId)
        url = url_for_resource("download/#{uploadId}")
        do_http_get(url, {}, headers)
      end

    end
  end
end
