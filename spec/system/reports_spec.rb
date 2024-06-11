require 'rails_helper'

RSpec.describe 'Reports', type: :system do
  before do
    @report = FactoryBot.create(:report)
  end

  describe 'ログイン' do
    context 'フォームの入力値が正常な場合' do
      it 'ログインに成功する' do
        visit '/'
        fill_in 'Eメール', with: @report.user.email
        fill_in 'パスワード', with: @report.user.password
        click_on 'ログイン'
        expect(page).to have_content 'ログインしました'
      end
    end

    context 'フォームの入力値が間違っている場合' do
      it 'ログインに失敗する' do
        visit '/'
        fill_in 'Eメール', with: 'false@sample.com'
        fill_in 'パスワード', with: 'falsepassword'
        click_on 'ログイン'
        expect(page).to have_content 'Eメールまたはパスワードが違います'
      end
    end
  end

  describe 'ページ遷移確認' do
    before { sign_in(@report.user) }

    context '日報一覧ページに遷移' do
      it '日報一覧ページへのアクセスに成功する' do
        report_list = FactoryBot.create_list(:report, 3)
        visit reports_path
        expect(page).to have_content '日報の一覧'
        expect(page).to have_content report_list[0].title
        expect(page).to have_content report_list[1].title
        expect(page).to have_content report_list[2].title
      end
    end
    context '日報新規作成ページに遷移' do
      it '日報の新規作成ページのアクセスに成功する' do
        visit new_report_path
        expect(page).to have_content '日報の新規作成'
        expect(current_path).to eq new_report_path
      end
    end
    context '日報編集ページに遷移' do
      it '日報の編集ページのアクセスに成功する' do
        visit edit_report_path(@report)
        expect(page).to have_content '日報の編集'
        expect(current_path).to eq edit_report_path(@report)
      end
    end
    context '日報詳細ページに遷移' do
      it '日報の詳細ページにアクセスに成功する' do
        visit report_path(@report)
        expect(page).to have_content '日報の詳細'
        expect(current_path).to eq report_path(@report)
      end
    end
  end

  describe '日報新規作成' do
    before do
      sign_in(@report.user)
      visit new_report_path
    end

    context 'フォームの入力値が正常な場合' do
      it '日報の新規作成に成功する' do
        fill_in 'タイトル', with: 'test_report'
        fill_in '内容', with: 'todays report'
        click_on '登録する'
        expect(page).to have_content '日報が作成されました'
        expect(page).to have_content 'test_report'
        expect(page).to have_content 'todays report'
        expect(current_path).to eq '/reports/2'
      end
    end

    context 'titleが未入力の場合' do
      it '日報の新規作成に失敗する' do
        fill_in 'タイトル', with: ''
        fill_in '内容', with: 'title is blank'
        click_on '登録する'
        expect(page).to have_content 'タイトルを入力してください'
        expect(current_path).to eq new_report_path
      end
    end
  end

  describe '日報編集' do
    before do
      sign_in(@report.user)
      visit edit_report_path(@report)
    end

    context 'フォームの入力値が正常な場合' do
      it '日報の編集が成功する' do
        fill_in 'タイトル', with: '編集した日報'
        fill_in '内容', with: '編集済み'
        click_on '更新する'
        expect(page).to have_content '日報が更新されました'
        expect(page).to have_content '編集した日報'
        expect(page).to have_content '編集済み'
        expect(current_path).to eq report_path(@report)
      end
    end
    context 'titleが未入力の場合' do
      it '日報の編集が失敗する' do
        fill_in 'タイトル', with: ''
        fill_in '内容', with: '日報の内容'
        click_on '更新する'
        expect(page).to have_content 'タイトルを入力してください'
        expect(current_path).to eq edit_report_path(@report)
      end
    end
  end

  describe '日報削除' do
    it '日報の削除が成功する' do
      sign_in(@report.user)
      visit report_path(@report)
      click_on 'この日報を削除'
      expect(page).to have_content '日報が削除されました'
      expect(page).to_not have_content @report.title
      expect(current_path).to eq reports_path
    end
  end
end
