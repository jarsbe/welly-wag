require 'spec_helper'

describe CommentsController, type: :controller do

  let(:link) { create(:post) }
  let(:user) { create(:user) }
  let(:comment) { create(:comment) }

  describe "GET show" do
    before { get :show, { id: comment.id } }

    it { expect(response.status).to eq(200) }
    it { expect(assigns(:comment)).to eq(comment) }
  end

  describe "POST create" do

    context "signed in" do
      before { sign_in user }

      context "with valid params" do
        it {
          expect {
            post :create, comment: { post_id: link.id, content: "Test comment." }
          }.to change(Comment, :count).by (1)
        }
      end

      context "with invalid params" do
        it {
          expect {
            post :create, comment: { post_id: link.id, content: "" }
          }.to change(Comment, :count).by (0)
        }
      end
    end

    context "signed out" do
      before { post :create }

      it { expect(subject).to redirect_to(new_user_session_path) }
    end
  end
end
