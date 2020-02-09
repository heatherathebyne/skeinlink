RSpec.shared_examples 'successful response' do
  it 'renders successfully' do
    expect(response.status).to eq 200
  end
end

RSpec.shared_examples 'redirects to login' do
  it 'redirects to login page' do
    expect(response).to redirect_to new_user_session_path
  end
end

RSpec.shared_examples 'redirects back to projects' do
  it 'redirects back to projects' do
    expect(response).to redirect_to(projects_path)
  end
end
