<?php

namespace Tests\Feature;

use Tests\TestCase;

class SlackTest extends TestCase
{

    public function test_can_slack(): void
    {
        $this->assertNotEmpty(config('services.slack.secret'));
    }
}
