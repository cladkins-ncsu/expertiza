class SimiCheckWebService
  @api_key = PLAGIARISM_CHECKER_CONFIG['simicheck_api_key']
  @base_uri = 'https://www.simicheck.com/api'
  ############################################
  # Comparison Operations
  ############################################
  # Lists all comparisons for the SimiCheck account
  # Parameters:
  #   <none>
  # Returns:
  #   response = RestClient::Response
  def self.all_comparisons
    request_execute(:get, '/comparisons', make_short_header)
  end

  private def request_execute(method_sym, url, header_func)
    RestClient::Request.execute(method: method_sym,
                                url: full_url(url),
                                headers: header_func,
                                verify_ssl: false)
  end
  private def request_execute_payload(method_sym, url, json_body, header_func)
    RestClient::Request.execute(method: method_sym,
                                url: full_url(url),
                                payload: json_body,
                                headers: header_func,
                                verify_ssl: false)
  end


  # Creates a new comparison
  # Parameters:
  #   comparison_name (optional) - string containing the name for the new comparison
  #                                (name will be date and time if not provided)
  # Returns:
  #   response = RestClient::Response
  # DRY headers
  def self.new_comparison(comparison_name = '')
    # full_url = @base_uri + '/comparison'
    json_body = {comparison_name: comparison_name}.to_json
    request_execute_payload(:put, '/comparison', json_body, make_header)
  end

  # Deletes a comparison
  # Parameters:
  #   comparison_id - string id of the comparison to delete
  # Returns:
  #   response = RestClient::Response (NO BODY)
  def self.delete_comparison(comparison_id)
    # full_url = @base_uri + '/comparison/' + comparison_id
    request_execute(:delete, '/comparison/' + comparison_id, make_short_header)
  end

  # Gets the details about a comparison
  # Parameters:
  #   comparison_id - string id of the comparison to look up
  # Returns:
  #   response = RestClient::Response
  def self.get_comparison_details(comparison_id)
    # full_url = @base_uri + '/comparison/' + comparison_id
    request_execute(:get, '/comparison/' + comparison_id, make_short_header)
    # RestClient::Request.execute(method: :get,
    #                             url: full_url('/comparison/' + comparison_id),
    #                             headers: make_short_header,
    #                             verify_ssl: false)
  end

  # Updates a comparison (currently only the name)
  # Parameters:
  #   comparison_id - string id of the comparison to update
  #   new_comparison_name - string containing the new name for the comparison
  # Returns:
  #   response = RestClient::Response (NO BODY)
  # DRY headers
  def self.update_comparison(comparison_id, new_comparison_name)
    # full_url = @base_uri + '/comparison/' + comparison_id
    json_body = {comparison_name: new_comparison_name}.to_json
    request_execute_payload(:post, '/comparison/' + comparison_id, json_body, make_header)
    # RestClient::Request.execute(method: :post,
    #                             url: full_url('/comparison/' + comparison_id),
    #                             payload: comparison_json_body(new_comparison_name),
    #                             headers: make_header,
    #                             verify_ssl: false)
  end

  ############################################
  # File Operations
  ############################################

  # Uploads a file
  # Parameters:
  #   comparison_id - string id of the comparison to update
  #   path_to_file - string containing the path to the file being uploaded
  # Returns:
  #   response = RestClient::Response
  def self.upload_file(comparison_id, path_to_file)
    # full_url = @base_uri + '/upload_file/' + comparison_id
    file_to_upload = File.new(path_to_file, 'rb')
    json_body = {"file" => file_to_upload} # don't use .to_json!
    request_execute_payload(:put, '/upload_file/' + comparison_id, json_body, make_header('multipart/form-data'))
    # RestClient::Request.execute(method: :put,
    #                             url: full_url('/upload_file/' + comparison_id),
    #                             payload: json_body,
    #                             headers: make_header('multipart/form-data'),
    #                             verify_ssl: false)
  end

  # Deletes files from a comparison
  # Parameters:
  #   comparison_id - string id of the comparison to update
  #   filenames_to_delete - array of strings containing filenames to be deleted
  # Returns:
  #   response = RestClient::Response (NO BODY)
  # DRY headers
  def self.delete_files(comparison_id, filenames_to_delete)
    # full_url = @base_uri + '/delete_files/' + comparison_id
    json_body = {"filenames" => filenames_to_delete}.to_json
    request_execute_payload(:post, '/delete_files/' + comparison_id, json_body, make_header)
    # RestClient::Request.execute(method: :post,
    #                             url: full_url('/delete_files/' + comparison_id),
    #                             payload: json_body,
    #                             headers: make_header,
    #                             verify_ssl: false)
  end

  ############################################
  # Similarity
  ############################################

  # Gets the results of the similarity comparison
  # Parameters:
  #   comparison_id - string id of the comparison to update
  # Returns:
  #   response = RestClient::Response
  def self.get_similarity_nxn(comparison_id)
    # full_url = @base_uri + '/similarity_nxn/' + comparison_id
    request_execute(:get, '/similarity_nxn/' + comparison_id, make_short_header)
    # RestClient::Request.execute(method: :get,
    #                             url: full_url('/similarity_nxn/' + comparison_id),
    #                             headers: make_short_header,
    #                             verify_ssl: false)
  end

  # Starts the computation of file similarity for a comparison
  # Parameters:
  #   comparison_id - string id of the comparison to update
  # Returns:
  #   response = RestClient::Response
  # DRY headers
  def self.post_similarity_nxn(comparison_id, callback_url = '')
    # full_url = @base_uri + '/similarity_nxn/' + comparison_id
    json_body = callback_url.empty? ? {}.to_json : {"callback_url" => callback_url}.to_json
    request_execute_payload(:post, '/similarity_nxn/' + comparison_id, json_body, make_header)
    # RestClient::Request.execute(method: :post,
    #                             url: full_url('/similarity_nxn/' + comparison_id),
    #                             payload: json_body,
    #                             headers: make_header,
    #                             verify_ssl: false)
  end

  # # Checks where a NxN comparison has terminated - NOT WORKING?
  # def self.get_similarity_status(comparison_id)
  #   full_url = @base_uri + '/similarity_status/' + comparison_id
  #   puts full_url
  #   RestClient::Request.execute(method: :get,
  #                                          url: full_url,
  #                                          headers:
  #                                              {
  #                                                  simicheck_api_key: @api_key,
  #                                                  accept: :json
  #                                              },
  #                                          verify_ssl: false)
  # end

  # Gets the latest results for the similarity of one file wrt. all other files in a comparison
  # DRY headers
  def self.get_similarity_1xn(comparison_id, filename)
    # full_url = @base_uri + '/similarity_1xn/' + comparison_id
    json_body = {"filename" => filename}.to_json
    request_execute_payload(:get, '/similarity_1xn/' + comparison_id, json_body, make_header)
    # RestClient::Request.execute(method: :get,
    #                             url: full_url('/similarity_1xn/' + comparison_id),
    #                             payload: json_body,
    #                             headers: make_header,
    #                             verify_ssl: false)
  end

  # Finds the files in a comparison that are most similar to a given file
  # DRY headers
  def self.post_similarity_1xn(comparison_id, filename, callback_url = '')
    # full_url = @base_uri + '/similarity_1xn/' + comparison_id
    json_body = callback_url.empty? ? {"filename" => filename}.to_json : {"filename" => filename, "callback_url" => callback_url}.to_json
    request_execute_payload(:post, '/similarity_1xn/' + comparison_id, json_body, make_header)
    # RestClient::Request.execute(method: :post,
    #                             url: full_url('/similarity_1xn/' + comparison_id),
    #                             payload: json_body,
    #                             headers: make_header,
    #                             verify_ssl: false)
  end

  ############################################
  # Visualization
  ############################################

  # Gets the results of the similarity comparison
  def self.visualize_similarity(comparison_id)
    # full_url = @base_uri + '/visualize_similarity/' + comparison_id
    request_execute(:get, '/visualize_similarity/' + comparison_id, make_short_header)
    # RestClient::Request.execute(method: :get,
    #                             url: full_url('/visualize_similarity/' + comparison_id),
    #                             headers: make_short_header,
    #                             verify_ssl: false)
  end

  # Gets the results of similarity comparison
  def self.visualize_comparison(comparison_id, file_id1, file_id2)
    # full_url = @base_uri + '/visualize_comparison/' + comparison_id + '/' + file_id1 + '/' + file_id2
    request_execute(:get, '/visualize_comparison/' + comparison_id + '/' + file_id1 + '/' + file_id2, make_short_header)
    # RestClient::Request.execute(method: :get,
    #                             url: full_url('/visualize_comparison/' + comparison_id + '/' + file_id1 + '/' + file_id2),
    #                             headers: make_short_header,
    #                             verify_ssl: false)
  end

  private def full_url(dir)
    @base_uri + dir
  end

  private def make_short_header
    {simicheck_api_key: @api_key}
  end

  private def make_header(content_type = nil)
    # ret = make_short_header
    if content_type.nil?
      ret = make_short_header[content_type: :json]
    else
      ret = make_short_header[content_type: content_type]
    end
    ret[accept: :json]
  end

end
