import { expect, test } from '@playwright/test';

test.describe('Home page', () => {
  test('displays the join form with name and room fields', async ({ page }) => {
    await page.goto('/');

    await expect(page.getByRole('heading', { name: 'VideoRTC' })).toBeVisible();
    await expect(page.getByLabel('Your Name')).toBeVisible();
    await expect(page.getByLabel('Room ID')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Join Call' })).toBeVisible();
  });

  test('generates an eight-character room ID', async ({ page }) => {
    await page.goto('/');

    const roomInput = page.getByLabel('Room ID');
    await page.getByRole('button', { name: 'Generate' }).click();

    await expect(roomInput).toHaveValue(/[a-z0-9]{8}/);
  });

  test('navigates to the call page after filling the form and joining', async ({ page }) => {
    await page.goto('/');

    await page.getByLabel('Your Name').fill('Test User');
    await page.getByLabel('Room ID').fill('test-room-123');
    await page.getByRole('button', { name: 'Join Call' }).click();

    await expect(page).toHaveURL(/\/call\?room=test-room-123&name=Test(\+|%20)User/);
  });

  test('does not navigate when required fields are empty', async ({ page }) => {
    await page.goto('/');

    await page.getByRole('button', { name: 'Join Call' }).click();

    await expect(page).toHaveURL('/');
  });

  test('does not navigate when either required field contains only whitespace', async ({ page }) => {
    await page.goto('/');

    await page.getByLabel('Your Name').fill('   ');
    await page.getByLabel('Room ID').fill('room-123');
    await page.getByRole('button', { name: 'Join Call' }).click();
    await expect(page).toHaveURL('/');

    await page.getByLabel('Your Name').fill('Test User');
    await page.getByLabel('Room ID').fill('   ');
    await page.getByRole('button', { name: 'Join Call' }).click();
    await expect(page).toHaveURL('/');
  });

  test('encodes special characters in the call URL', async ({ page }) => {
    await page.goto('/');

    await page.getByLabel('Your Name').fill('Matti & Co');
    await page.getByLabel('Room ID').fill('room/one');
    await page.getByRole('button', { name: 'Join Call' }).click();

    await expect(page).toHaveURL(/\/call\?room=room%2Fone&name=Matti(%20|\+)%26(%20|\+)Co/);
  });
});
