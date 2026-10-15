import { expect, test } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test.describe('Accessibility', () => {
  test('finds no detectable axe violations on the home page', async ({ page }) => {
    await page.goto('/');

    const { violations } = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();

    expect(violations).toEqual([]);
  });

  test('labels the home page form controls', async ({ page }) => {
    await page.goto('/');

    await expect(page.getByLabel('Your Name')).toBeVisible();
    await expect(page.getByLabel('Room ID')).toBeVisible();
  });

  test('has a logical heading and instruction structure', async ({ page }) => {
    await page.goto('/');

    await expect(page.getByRole('heading', { level: 1, name: 'VideoRTC' })).toBeVisible();
    await expect(page.getByRole('heading', { level: 3, name: 'How it works:' })).toBeVisible();
    await expect(page.getByRole('list')).toBeVisible();
  });

  test('can be operated with the keyboard', async ({ page }) => {
    await page.goto('/');

    await page.keyboard.press('Tab');
    await expect(page.getByLabel('Your Name')).toBeFocused();
    await page.keyboard.type('Test User');
    await page.keyboard.press('Tab');
    await expect(page.getByLabel('Room ID')).toBeFocused();
    await page.keyboard.type('keyboard-room');
    await page.keyboard.press('Tab');
    await expect(page.getByRole('button', { name: 'Generate' })).toBeFocused();
    await page.keyboard.press('Tab');
    await expect(page.getByRole('button', { name: 'Join Call' })).toBeFocused();
    await page.keyboard.press('Enter');

    await expect(page).toHaveURL(/\/call\?room=keyboard-room&name=Test(\+|%20)User/);
  });
});
