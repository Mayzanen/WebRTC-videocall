import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

function callUrl(room: string, name: string): string {
  return `/call?room=${encodeURIComponent(room)}&name=${encodeURIComponent(name)}`;
}

test.describe('Call page controls', () => {
  test('renders mute, camera and hangup buttons once connected', async ({ page }) => {
    await page.goto(callUrl('controls-smoke-room', 'Tester'));

    await expect(page.getByRole('button', { name: /Mute microphone|Unmute microphone/ })).toBeVisible({
      timeout: 15_000,
    });
    await expect(page.getByRole('button', { name: /Turn off camera|Turn on camera/ })).toBeVisible();
    await expect(page.getByRole('button', { name: 'End call' })).toBeVisible();
  });

  test('toggling mute and camera updates pressed state and icon', async ({ page }) => {
    await page.goto(callUrl('controls-toggle-room', 'Tester'));

    const muteButton = page.getByRole('button', { name: /Mute microphone|Unmute microphone/ });
    await expect(muteButton).toBeVisible({ timeout: 15_000 });

    await expect(muteButton).toHaveAttribute('aria-pressed', 'false');
    await muteButton.click();
    await expect(muteButton).toHaveAttribute('aria-pressed', 'true');

    const cameraButton = page.getByRole('button', { name: /Turn off camera|Turn on camera/ });
    await expect(cameraButton).toHaveAttribute('aria-pressed', 'false');
    await cameraButton.click();
    await expect(cameraButton).toHaveAttribute('aria-pressed', 'true');
  });

  test('controls bar has no detectable axe violations', async ({ page }) => {
    await page.goto(callUrl('controls-axe-room', 'Tester'));

    await expect(page.getByRole('button', { name: 'End call' })).toBeVisible({ timeout: 15_000 });

    const results = await new AxeBuilder({ page })
      .include('.controls-container')
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
      .analyze();

    await test.info().attach('controls-axe-results.json', {
      body: JSON.stringify(results.violations, null, 2),
      contentType: 'application/json',
    });

    expect(results.violations, formatViolations(results.violations)).toEqual([]);
  });

  test('uses CSS-controlled SVG icons with accessible button names', async ({ page }) => {
    await page.goto(callUrl('controls-known-gap-room', 'Tester'));

    const muteButton = page.getByRole('button', { name: /Mute microphone|Unmute microphone/ });
    const cameraButton = page.getByRole('button', { name: /Turn off camera|Turn on camera/ });
    const hangupButton = page.getByRole('button', { name: 'End call' });

    await expect(muteButton).toBeVisible({ timeout: 15_000 });
    await expect(cameraButton).toBeVisible();
    await expect(hangupButton).toBeVisible();

    await expect(muteButton).toHaveAccessibleName(/Mute microphone|Unmute microphone/);
    await expect(cameraButton).toHaveAccessibleName(/Turn off camera|Turn on camera/);
    await expect(hangupButton).toHaveAccessibleName('End call');

    await expect(muteButton.locator('svg')).toHaveAttribute('aria-hidden', 'true');
    await expect(cameraButton.locator('svg')).toHaveAttribute('aria-hidden', 'true');
    await expect(hangupButton.locator('svg')).toHaveAttribute('aria-hidden', 'true');
  });
});

function formatViolations(
  violations: { id: string; impact?: string | null; help: string; nodes: { target: string[] }[] }[]
): string {
  if (violations.length === 0) return 'No violations';

  return violations
    .map(
      (v) =>
        `${v.id} (${v.impact}): ${v.help} — ${v.nodes.length} node(s): ${v.nodes
          .map((n) => n.target.join(' '))
          .join(', ')}`
    )
    .join('\n');
}
