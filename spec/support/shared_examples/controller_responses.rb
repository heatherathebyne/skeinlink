RSpec.shared_examples 'successful response' do
  it 'renders successfully' do
    expect(response.status).to eq 200
  end
end

RSpec.shared_examples 'unauthorized response' do
  it 'renders an unauthorized response' do
    expect(response.status).to eq 401
  end
end

RSpec.shared_examples 'redirects to login' do
  it 'redirects to login page' do
    expect(response).to redirect_to new_user_session_path
  end
end

RSpec.shared_examples 'redirects back to projects' do
  it 'redirects back to projects' do
    expect(response).to redirect_to projects_path
  end
end

RSpec.shared_examples 'redirects to root path' do
  it 'redirects to root path' do
    expect(response).to redirect_to root_path
  end
end

RSpec.shared_examples 'displays maintainer flash' do
  it 'displays maintainer flash' do
    expect(flash[:alert]).to eq 'Only maintainers can change this.'
  end
end

RSpec.shared_examples 'displays unauthorized flash' do
  it 'displays unauthorized flash' do
    expect(flash[:alert]).to eq "Sorry, but you don't have permission to do that."
  end
end
