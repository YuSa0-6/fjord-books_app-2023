# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  include Warden::Test::Helpers
  setup do
    Warden.test_mode!
    @user = users(:alice)
  end
  test 'login' do
    visit '/'
    fill_in 'Eメール', with: @user.email
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました。'
  end
  test 'visiting the index' do
    login_as(users(:alice))
    visit '/reports/'
    assert_text '日報の一覧'
  end
  test 'create a report' do
    login_as(users(:alice))
    visit '/reports/new'
    fill_in 'タイトル', with: '新規日報'
    fill_in '内容', with: '今日は晴天なり'
    click_on '登録する'
    assert_text '日報が作成されました。'
    assert_text '新規日報'
    assert_text '今日は晴天なり'
  end

  test 'update a report' do
    visit '/reports/1/edit'
    fill_in 'タイトル', with: '更新した日報'
    fill_in '内容', with: '今日は雨'
    click_on '更新する'
    assert_text '日報が更新されました。'
  end

  test 'destroy a report' do
    visit '/reports/1'
    click_on 'この日報を削除'
    assert_text '日報が削除されました。'
  end
end
